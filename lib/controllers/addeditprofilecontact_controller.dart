import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/contact.dart';
import '../controllers/contact_controller.dart';

class AddEditProfileContactController extends GetxController {
  final Contact? contact;
  final ContactController contactController = Get.find<ContactController>();

  // Text controllers
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController landlineController;
  late TextEditingController emailController;
  late TextEditingController whatsappController;
  late TextEditingController facebookController;
  late TextEditingController instagramController;
  late TextEditingController youtubeController;
  late TextEditingController websiteController;

  // Focus nodes
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode landFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode whatsappFocusNode;
  late FocusNode facebookFocusNode;
  late FocusNode instagramFocusNode;
  late FocusNode youtubeFocusNode;
  late FocusNode websiteFocusNode;

  // Reactive lists
  RxList<Map<String, dynamic>> customFields = <Map<String, dynamic>>[].obs;
  RxList<TextEditingController> phoneNumbersControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> emailAddressesControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> landlineNumbersControllers = <TextEditingController>[].obs;

  AddEditProfileContactController(this.contact);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: contact?.name ?? '');
    phoneController = TextEditingController(text: contact?.phone ?? '');
    landlineController = TextEditingController(text: contact?.landline ?? '');
    emailController = TextEditingController(text: contact?.email ?? '');
    whatsappController = TextEditingController(text: contact?.whatsapp ?? '');
    facebookController = TextEditingController(text: contact?.facebook ?? '');
    instagramController = TextEditingController(text: contact?.instagram ?? '');
    youtubeController = TextEditingController(text: contact?.youtube ?? '');
    websiteController = TextEditingController(text: contact?.website ?? '');

    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    landFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    whatsappFocusNode = FocusNode();
    facebookFocusNode = FocusNode();
    instagramFocusNode = FocusNode();
    youtubeFocusNode = FocusNode();
    websiteFocusNode = FocusNode();

    if (contact != null) {
      contact!.customFields?.forEach((label, value) {
        customFields.add({
          'label': label,
          'labelController': TextEditingController(text: label),
          'valueController': TextEditingController(text: value),
        });
      });
      contact!.phoneNumbers?.forEach((phone) {
        phoneNumbersControllers.add(TextEditingController(text: phone));
      });
      contact!.emailAddresses?.forEach((email) {
        emailAddressesControllers.add(TextEditingController(text: email));
      });
      contact!.landlineNumbers?.forEach((landline) {
        landlineNumbersControllers.add(TextEditingController(text: landline));
      });
    }
  }

  bool validateFields(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name is a required field.'), backgroundColor: Colors.red),
      );
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9\s\u0D00-\u0D7F]+$').hasMatch(nameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid name in English, Malayalam, or with numbers.'), backgroundColor: Colors.red),
      );
      return false;
    }
    return true;
  }

  void saveContact(BuildContext context) {
    if (!validateFields(context)) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to save a contact.');
      return;
    }

    Map<String, String> customFieldsMap = Map.fromEntries(
      customFields.map((field) => MapEntry(
            field['labelController']!.text,
            field['valueController']!.text,
          )),
    );
    List<String> phoneNumbers = phoneNumbersControllers
        .map((controller) => controller.text)
        .where((number) => number.isNotEmpty)
        .toList();
    List<String> emailAddresses = emailAddressesControllers
        .map((controller) => controller.text)
        .where((email) => email.isNotEmpty)
        .toList();
    List<String> landlineNumbers = landlineNumbersControllers
        .map((controller) => controller.text)
        .where((landline) => landline.isNotEmpty)
        .toList();

    bool isAdmin = contactController.isAdmin();

    if (contact == null) {
      Contact newContact = Contact(
        id: '',
        name: nameController.text,
        phone: phoneController.text,
        landline: landlineController.text,
        email: emailController.text,
        ownerId: user.uid, // <-- FIXED HERE
        customFields: customFieldsMap,
        phoneNumbers: phoneNumbers,
        emailAddresses: emailAddresses,
        landlineNumbers: landlineNumbers,
        whatsapp: whatsappController.text,
        facebook: facebookController.text,
        instagram: instagramController.text,
        youtube: youtubeController.text,
        website: websiteController.text,
        isFavorite: false,
      );
      if (isAdmin) {
        contactController.addContactToFirebaseIfAdmin(newContact);
      } else {
        contactController.addContact(newContact);
      }
      Navigator.pop(context, newContact);
    } else {
      contact!
        ..name = nameController.text
        ..phone = phoneController.text
        ..landline = landlineController.text
        ..email = emailController.text
        ..customFields = customFieldsMap
        ..phoneNumbers = phoneNumbers
        ..emailAddresses = emailAddresses
        ..landlineNumbers = landlineNumbers
        ..whatsapp = whatsappController.text
        ..facebook = facebookController.text
        ..instagram = instagramController.text
        ..youtube = youtubeController.text
        ..website = websiteController.text;

      contactController.editContact(
        contact: contact!,
        name: contact!.name,
        phone: contact!.phone,
        landline: contact!.landline,
        email: contact!.email,
        phoneNumbers: contact!.phoneNumbers,
        landlineNumbers: contact!.landlineNumbers,
        emailAddresses: contact!.emailAddresses,
        customFields: contact!.customFields,
        whatsapp: contact!.whatsapp,
        facebook: contact!.facebook,
        instagram: contact!.instagram,
        youtube: contact!.youtube,
      );

      if (isAdmin) {
        contactController.updateContactToFirebaseIfAdmin(contact!);
      } else {
        contactController.updateContact(contact!);
      }
      Navigator.pop(context, contact);
    }
  }

  // Add/remove methods
  void addPhoneNumber() => phoneNumbersControllers.add(TextEditingController());
  void removePhoneNumber(int index) => phoneNumbersControllers.removeAt(index);

  void addEmailAddress() => emailAddressesControllers.add(TextEditingController());
  void removeEmailAddress(int index) => emailAddressesControllers.removeAt(index);

  void addLandlineNumbers() => landlineNumbersControllers.add(TextEditingController());
  void removeLandlineNumbers(int index) => landlineNumbersControllers.removeAt(index);

  void addCustomField() {
    customFields.add({
      'label': '',
      'labelController': TextEditingController(),
      'valueController': TextEditingController(),
    });
  }
  void removeCustomField(int index) => customFields.removeAt(index);

  Future<void> publishContactToFirebase(Contact contact) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to publish.');
      return;
    }
    contact.ownerId = user.uid;

    try {
      // Check for duplicate by name and (phone or email) for this user
      final query = await FirebaseFirestore.instance
          .collection('contacts')
          .where('name', isEqualTo: contact.name)
          .where('ownerId', isEqualTo: user.uid)
          .get();

      DocumentReference? duplicateDoc;
      for (var doc in query.docs) {
        final data = doc.data();
        if (
          (data['phone'] == contact.phone && contact.phone.isNotEmpty) ||
          (data['email'] == contact.email && contact.email.isNotEmpty)
        ) {
          duplicateDoc = doc.reference;
          break;
        }
      }

      if (duplicateDoc != null) {
        // Update the existing duplicate contact
        await duplicateDoc.update({
          'name': contact.name,
          'phone': contact.phone,
          'landline': contact.landline,
          'email': contact.email,
          'ownerId': contact.ownerId,
          'customFields': contact.customFields,
          'phoneNumbers': contact.phoneNumbers,
          'emailAddresses': contact.emailAddresses,
          'landlineNumbers': contact.landlineNumbers,
          'whatsapp': contact.whatsapp,
          'facebook': contact.facebook,
          'instagram': contact.instagram,
          'youtube': contact.youtube,
          'website': contact.website,
          'isFavorite': contact.isFavorite,
        });
        Get.snackbar('Updated', 'Duplicate found. Existing contact updated.');
      } else {
        // No duplicate, create new
        await FirebaseFirestore.instance
            .collection('contacts')
            .add({
          'name': contact.name,
          'phone': contact.phone,
          'landline': contact.landline,
          'email': contact.email,
          'ownerId': contact.ownerId,
          'customFields': contact.customFields,
          'phoneNumbers': contact.phoneNumbers,
          'emailAddresses': contact.emailAddresses,
          'landlineNumbers': contact.landlineNumbers,
          'whatsapp': contact.whatsapp,
          'facebook': contact.facebook,
          'instagram': contact.instagram,
          'youtube': contact.youtube,
          'website': contact.website,
          'isFavorite': contact.isFavorite,
        });
        Get.snackbar('Success', 'Contact published to Firebase.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to publish contact: $e');
    }
  }
}