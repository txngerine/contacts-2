import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../model/contact.dart';
import 'auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ContactController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController authController = Get.find<AuthController>();
  late Box<Contact> contactBox;

  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> filteredContacts = <Contact>[].obs;
  RxString searchQuery = ''.obs;
  RxMap<String, List<Contact>> groupedContacts = <String, List<Contact>>{}.obs;
  final RxMap<String, dynamic> contactData = <String, dynamic>{}.obs;

  Map<String, dynamic> _contactInfo = {};

  Map<String, dynamic> get contactInfo => _contactInfo;

  set contactInfo(Map<String, dynamic> value) {
    _contactInfo = value;
    update(); // Notify listeners (if you use GetX's update mechanism)
  }

  var isFetching = false.obs;
  var loadingMore = false.obs;

  DocumentSnapshot? lastVisible;
  final int pageSize = 9000;

  RxSet<Contact> selectedContacts = <Contact>{}.obs;
  RxBool isSelectionMode = false.obs;
RxList<Contact> deletedContacts = <Contact>[].obs;

  @override
  void onInit() {
    super.onInit();
    contactBox = Hive.box<Contact>('contacts');
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (isFetching.value) return;
    isFetching.value = true;

    try {
      final user = authController.firebaseUser.value;
      if (user == null) throw Exception('User not authenticated');

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final isAdmin = userDoc.exists && userDoc.data()?['role'] == 'admin';

      Query<Map<String, dynamic>> query;

      if (isAdmin) {
        query = firestore.collection('contacts').limit(pageSize);
      } else {
        query = firestore
            .collection('contacts')
            .where('ownerId', whereIn: [user.uid, 'admin']).limit(pageSize);
      }

      final snapshot = await query.get();

      final firestoreContacts = snapshot.docs
          .map((doc) => Contact.fromMap(doc.id, doc.data()))
          .toList();

      // Merge with local Hive contacts
      final localContacts = contactBox.values.toList();

      final allContacts = [
        ...firestoreContacts,
        ...localContacts.where((local) =>
            !firestoreContacts.any((remote) => remote.id == local.id))
      ];

      await contactBox.clear();
      for (var contact in allContacts) {
        await contactBox.put(contact.id, contact);
      }

      contacts.value = allContacts;
      if (snapshot.docs.isNotEmpty) lastVisible = snapshot.docs.last;
    } catch (e) {
      contacts.value = contactBox.values.toList();
      Get.snackbar('Offline Mode', 'Loaded contacts from local storage.');
    } finally {
      filterContacts();
      isFetching.value = false;
    }
  }

  Future<void> syncSelectedContacts() async {
    final List<Contact> unsyncedContacts = selectedContacts
        .where((c) => !c.isSynced && c.ownerId.isNotEmpty)
        .toList();

    if (unsyncedContacts.isEmpty) {
      Get.snackbar('No Changes', 'All selected contacts are already synced.');
      return;
    }

    int successCount = 0;
    List<String> failedContactNames = [];

    for (final contact in unsyncedContacts) {
      try {
        await syncContactToFirestore(contact);
        successCount++;
      } catch (e) {
        failedContactNames.add(contact.name);
        print('Sync failed for contact [${contact.id}]: $e');
      }
    }

    if (successCount > 0) {
      Get.snackbar(
          'Sync Complete', '$successCount contact(s) synced successfully.');
    }

    if (failedContactNames.isNotEmpty) {
      Get.snackbar(
        'Sync Failed',
        'Could not sync: ${failedContactNames.join(', ')}',
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> loadMoreContacts() async {
    if (loadingMore.value || lastVisible == null) return;
    loadingMore.value = true;

    try {
      final userId = authController.firebaseUser.value?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await firestore
          .collection('contacts')
          .where('ownerId', whereIn: [userId, 'admin'])
          .startAfterDocument(lastVisible!)
          .limit(pageSize)
          .get();

      final newContacts = snapshot.docs
          .map((doc) => Contact.fromMap(doc.id, doc.data()))
          .toList();

      // Add only new contacts not already in the list
      for (var contact in newContacts) {
        if (!contacts.any((c) => c.id == contact.id)) {
          contacts.add(contact);
          await contactBox.put(contact.id, contact);
        }
      }

      if (snapshot.docs.isNotEmpty) lastVisible = snapshot.docs.last;

      filterContacts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more contacts: $e');
    } finally {
      loadingMore.value = false;
    }
  }

  Future<void> addContact(Contact contact) async {
    final ownerId = authController.userRole.value == 'admin'
        ? 'admin'
        : authController.firebaseUser.value!.uid;

    final localId = UniqueKey().toString();
    final updatedContact = contact.copyWith(
      id: localId,
      ownerId: ownerId,
      isSynced: false,
    );

    contacts.add(updatedContact);
    await contactBox.put(localId, updatedContact);
    filterContacts();
  }

  Future<void> editContact({
    required Contact contact,
    required String name,
    required String phone,
    required String? landline,
    required String email,
    List<String>? phoneNumbers,
    List<String>? landlineNumbers,
    List<String>? emailAddresses,
    Map<String, String>? customFields,
    String? whatsapp,
    String? facebook,
    String? instagram,
    String? youtube,
  }) async {
    final updatedContact = contact.copyWith(
      name: name,
      phone: phone,
      landline: landline ?? contact.landline,
      email: email,
      phoneNumbers: phoneNumbers ?? contact.phoneNumbers,
      landlineNumbers: landlineNumbers ?? contact.landlineNumbers,
      emailAddresses: emailAddresses ?? contact.emailAddresses,
      facebook: facebook ?? contact.facebook,
      whatsapp: whatsapp ?? contact.whatsapp,
      instagram: instagram ?? contact.instagram,
      youtube: youtube ?? contact.youtube,
      customFields: customFields ?? contact.customFields,
      isSynced: false,
    );

    updateContact(updatedContact);
    await contactBox.put(updatedContact.id, updatedContact);
    filterContacts();

    // Auto-sync edit
    syncContactToFirestore(updatedContact);
  }

  // Future<void> deleteContact(Contact contact) async {
  //   contacts.removeWhere((c) => c.id == contact.id);
  //   await contactBox.delete(contact.id);
  //   filterContacts();
  // }

  Future<void> deleteContact(Contact contact) async {
  contacts.removeWhere((c) => c.id == contact.id);
  deletedContacts.add(contact); // Move to recycle bin
  await contactBox.delete(contact.id);
  filterContacts();
}

  Future<void> restoreContact(Contact contact) async {
    // deletedContacts.remove(contact);
    deletedContacts.removeWhere((c) => c.id == contact.id);
    contacts.add(contact);
    await contactBox.put(contact.id, contact);
    filterContacts();
  }
  Future<void> permanentlyDeleteContact(Contact contact) async {
    deletedContacts.remove(contact);
    await contactBox.delete(contact.id);
    filterContacts();
  }

  Future<void> loadContactDetails(String userId) async {
    try {
      // Step 1: Fetch the user's username from the `users` collection
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final username = userSnapshot.data()?['username'];

        if (username != null && username.toString().trim().isNotEmpty) {
          // Step 2: Search in `contacts` collection where `name` == `username`
          final querySnapshot = await FirebaseFirestore.instance
              .collection('contacts')
              .where('name', isEqualTo: username)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            contactData.value = querySnapshot.docs.first.data();
          } else {
            contactData.clear();
            print('No contact found for username: $username');
          }
        }
      }
    } catch (e) {
      print('Error loading contact details: $e');
    }
  }

  Future<void> toggleFavorite(Contact contact) async {
    final updatedStatus = !contact.isFavorite;

    final updatedContact = contact.copyWith(
      isFavorite: updatedStatus,
    );

    contacts[contacts.indexWhere((c) => c.id == contact.id)] = updatedContact;
    await contactBox.put(updatedContact.id, updatedContact);
    filterContacts();
  }

  Future<void> syncContactToFirestore(Contact contact) async {
    try {
      final docRef = contact.id.length < 20
          ? null
          : firestore.collection('contacts').doc(contact.id);

      if (docRef == null) {
        final newDoc =
            await firestore.collection('contacts').add(contact.toMap());
        final synced = contact.copyWith(id: newDoc.id, isSynced: true);

        contacts.removeWhere((c) => c.id == contact.id);
        contacts.add(synced);
        await contactBox.delete(contact.id);
        await contactBox.put(synced.id, synced);
      } else {
        await docRef.set(contact.toMap());
        final synced = contact.copyWith(isSynced: true);
        contacts[contacts.indexWhere((c) => c.id == contact.id)] = synced;
        await contactBox.put(synced.id, synced);
      }

      filterContacts();
    } catch (e) {
      print('Sync failed for contact ${contact.id}: $e');
    }
  }

  Future<void> addContactToFirebaseIfAdmin(Contact contact) async {
    final role = authController.userRole.value;
    if (role == 'admin') {
      try {
        final docRef = await firestore
            .collection('contacts')
            .add(contact.copyWith(ownerId: 'admin', isSynced: true).toMap());
        final addedContact =
            contact.copyWith(id: docRef.id, ownerId: 'admin', isSynced: true);
        contacts.add(addedContact);
        await contactBox.put(addedContact.id, addedContact);
        filterContacts();
        Get.snackbar('Success', 'Contact added to Firebase as admin!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add contact to Firebase: $e');
      }
    } else {
      Get.snackbar('Permission Denied',
          'Only admins can add contacts directly to Firebase.');
    }
  }

  Future<void> deleteContactFromFirebaseIfAdmin(Contact contact) async {
    final role = authController.userRole.value;
    if (role == 'admin') {
      try {
        await firestore.collection('contacts').doc(contact.id).delete();
        contacts.removeWhere((c) => c.id == contact.id);
        await contactBox.delete(contact.id);
        filterContacts();
        Get.snackbar('Success', 'Contact deleted from Firebase!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete contact from Firebase: $e');
      }
    } else {
      Get.snackbar('Permission Denied',
          'Only admins can delete contacts from Firebase.');
    }
  }

  Future<void> updateContactToFirebaseIfAdmin(Contact contact) async {
    final role = authController.userRole.value;
    if (role == 'admin') {
      try {
        await firestore.collection('contacts').doc(contact.id).set(
              contact.copyWith(ownerId: 'admin', isSynced: true).toMap(),
            );

        final updatedContact =
            contact.copyWith(ownerId: 'admin', isSynced: true);
        contacts[contacts.indexWhere((c) => c.id == updatedContact.id)] =
            updatedContact;
        await contactBox.put(updatedContact.id, updatedContact);
        filterContacts();
        Get.snackbar('Success', 'Contact updated in Firebase as admin!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to update contact in Firebase: $e');
      }
    } else {
      Get.snackbar(
          'Permission Denied', 'Only admins can update contacts in Firebase.');
    }
  }

  bool isAdmin() {
    return authController.userRole.value == 'admin';
  }

  void filterContacts() {
    if (searchQuery.value.isEmpty) {
      filteredContacts.value = contacts;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredContacts.value = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phone.contains(query);
      }).toList();
    }

    filteredContacts.sort((a, b) => a.name.compareTo(b.name));

    final Map<String, List<Contact>> grouped = {};
    for (var contact in filteredContacts) {
      final firstLetter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(firstLetter, () => []).add(contact);
    }

    groupedContacts.value = grouped;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterContacts();
  }

  void updateContact(Contact updatedContact) {
    final index =
        contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      contacts[index] = updatedContact;
      filterContacts();
    }
  }

  //profilecontroller

  Future<void> saveOrUpdateContact(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    data['ownerId'] = user.uid;

    final String? name = data['name'] as String?;
    final String? email = data['email'] as String?;
    final String? phone = data['phone'] as String?;

    if (name == null || name.trim().isEmpty) {
      throw Exception('Name is required');
    }

    try {
      // Try to find existing contact in Hive by ownerId and name
      Contact? existing;
      try {
        existing = contactBox.values.firstWhere(
          (c) => c.ownerId == user.uid && c.name == name,
        );
      } catch (e) {
        existing = null;
      }

      if (existing != null) {
        // Update existing contact
        final updated = existing.copyWith(
          name: name,
          email: email ?? existing.email,
          phone: phone ?? existing.phone,
          isSynced: false,
        );
        await contactBox.put(updated.id, updated);
        updateContact(updated);
      } else {
        // Add new contact
        final localId = UniqueKey().toString();
        final newContact = Contact.fromMap(localId, {
          ...data,
          'id': localId,
          'isSynced': false,
        });

        await contactBox.put(localId, newContact);
        contacts.add(newContact);
      }

      filterContacts();

      // Update minimal profile fields in Firestore 'users' collection (only username since email may be null)
      final profileUpdateData = {
        'username': name,
      };
      if (email != null && email.trim().isNotEmpty) {
        profileUpdateData['email'] = email;
      }
      await firestore
          .collection('users')
          .doc(user.uid)
          .update(profileUpdateData);
    } catch (e) {
      throw Exception('Failed to save or update contact: $e');
    }
  }

  Future<void> deleteContactByName(String name) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final contactsRef = firestore.collection('contacts');
    final query = await contactsRef
        .where('ownerId', isEqualTo: user.uid)
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      await contactsRef.doc(docId).delete();

      await firestore.collection('users').doc(user.uid).update({
        'phone': FieldValue.delete(),
        'email': FieldValue.delete(),
        'facebook': FieldValue.delete(),
        'whatsapp': FieldValue.delete(),
        'instagram': FieldValue.delete(),
        'youtube': FieldValue.delete(),
      });
    } else {
      throw Exception('Contact not found for deletion');
    }
  }

  void toggleSelection(Contact contact) {
    if (selectedContacts.contains(contact)) {
      selectedContacts.remove(contact);
    } else {
      selectedContacts.add(contact);
    }
    isSelectionMode.value = selectedContacts.isNotEmpty;
  }

  void clearSelection() {
    selectedContacts.clear();
    isSelectionMode.value = false;
  }

  void shareSelectedContacts() {
    final contactDetails = selectedContacts
        .map((contact) => 'Name: ${contact.name}, Phone: ${contact.phone}')
        .join('\n');
    Share.share('Selected Contacts:\n$contactDetails');
  }
}
