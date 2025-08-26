import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart' hide Contact;
import 'package:file_picker/file_picker.dart';
import 'package:vcard_vcf/vcard.dart';
import 'package:hive/hive.dart'; // Add Hive import
import '../model/contact.dart';

class ContactImportController extends GetxController {
  var deviceContacts = <Contact>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadContactsFromHive();
  }

  Future<void> loadContactsFromHive() async {
    final contactsBox = await Hive.openBox<Contact>('contacts');
    deviceContacts.value = contactsBox.values.toList();
  }

  Future<void> fetchDeviceContacts() async {
    final permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) {
      Get.snackbar('Permission Denied', 'Contacts access is required.');
      return;
    }

    final rawContacts = await FlutterContacts.getContacts(withProperties: true);

    deviceContacts.value = rawContacts.map((c) {
      final phoneNumbers = c.phones.map((p) => p.number).toList();
      final emails = c.emails.map((e) => e.address).toList();

      return Contact(
        id: '',
        name: c.displayName,
        phone: phoneNumbers.isNotEmpty ? phoneNumbers.first : '',
        landline: null,
        email: emails.isNotEmpty ? emails.first : '',
        ownerId: '', // No firebase, so leave blank or use a local identifier
        isFavorite: false,
        phoneNumbers: phoneNumbers,
        landlineNumbers: [],
        emailAddresses: emails,
        customFields: {},
        whatsapp: null,
        facebook: null,
        instagram: null,
        youtube: null,
        isSynced: false,
      );
    }).toList();
  }

  Future<void> importContactsFromVcfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['vcf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();

      final lines = content.split(RegExp(r'\r?\n'));
      final contacts = <Contact>[];
      VCard? currentVCard;

      for (var line in lines) {
        line = line.trim();
        if (line == 'BEGIN:VCARD') {
          currentVCard = VCard();
        } else if (line == 'END:VCARD') {
          if (currentVCard != null) {
            final phoneNumbers = <String>[];
            final emails = <String>[];

            if (currentVCard.workPhone != null) {
              phoneNumbers.add(currentVCard.workPhone!);
            }
            if (currentVCard.homePhone != null) {
              phoneNumbers.add(currentVCard.homePhone!);
            }
            if (currentVCard.cellPhone != null) {
              phoneNumbers.add(currentVCard.cellPhone!);
            }
            if (currentVCard.email != null) {
              emails.add(currentVCard.email!);
            }

            contacts.add(Contact(
              id: '', // You may want to generate a unique id here
              name: currentVCard.firstName ?? '',
              phone: phoneNumbers.isNotEmpty ? phoneNumbers.first : '',
              landline: null,
              email: emails.isNotEmpty ? emails.first : '',
              ownerId: '',
              isFavorite: false,
              phoneNumbers: phoneNumbers,
              landlineNumbers: [],
              emailAddresses: emails,
              customFields: {},
              whatsapp: null,
              facebook: null,
              instagram: null,
              youtube: null,
              isSynced: false,
            ));
          }
          currentVCard = null;
        } else if (currentVCard != null) {
          final separatorIndex = line.indexOf(':');
          if (separatorIndex != -1) {
            final key = line.substring(0, separatorIndex).toUpperCase();
            final value = line.substring(separatorIndex + 1);

            switch (key) {
              case 'FN':
                currentVCard.firstName = value;
                break;
              case 'TEL;WORK':
                currentVCard.workPhone = value;
                break;
              case 'TEL;HOME':
                currentVCard.homePhone = value;
                break;
              case 'TEL;CELL':
                currentVCard.cellPhone = value;
                break;
              case 'EMAIL':
                currentVCard.email = value;
                break;
              // Add more cases as needed
            }
          }
        }
      }

      // Save imported contacts to Hive
      final contactsBox = await Hive.openBox<Contact>('contacts');
      for (var contact in contacts) {
        await contactsBox.add(contact);
      }

      // Show only the newly imported VCF contacts in deviceContacts
      deviceContacts.value = contacts;

      Get.snackbar('Import Successful',
          '${contacts.length} contacts imported from VCF.');
    } else {
      Get.snackbar('Import Cancelled', 'No VCF file selected.');
    }
  }
}
