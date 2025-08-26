import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../controllers/contact_import.dart';

class ContactImportFromVcfView extends StatelessWidget {
  final ContactImportController importController =
      Get.put(ContactImportController());
  final ContactController contactController = Get.find<ContactController>();
  final RxSet<int> selectedContacts = <int>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Import from VCF',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Clear Cache',
            onPressed: () {
              importController.deviceContacts.clear();
              selectedContacts.clear();
            },
          ),
          Obx(() {
            return importController.deviceContacts.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedContacts.length ==
                              importController.deviceContacts.length,
                          activeColor: Colors.green,
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedContacts.addAll(List.generate(
                                  importController.deviceContacts.length,
                                  (index) => index));
                            } else {
                              selectedContacts.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }),
          Obx(() {
            return selectedContacts.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      final selectedCount = selectedContacts.length;
                      for (final index in selectedContacts) {
                        final contact = importController.deviceContacts[index];
                        contact.ownerId = contactController
                            .authController.firebaseUser.value!.uid;
                        contactController.addContact(contact);
                      }
                      selectedContacts.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '$selectedCount contacts imported from VCF.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Import',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                importController.deviceContacts
                    .clear(); // Clear any previous contacts
                await importController.importContactsFromVcfFile();
              },
              icon: Icon(Icons.file_open),
              label: Text(
                'Select VCF File',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (importController.deviceContacts.isEmpty) {
                return Center(child: Text('No contacts loaded.'));
              }

              return ListView.builder(
                itemCount: importController.deviceContacts.length,
                itemBuilder: (context, index) {
                  final contact = importController.deviceContacts[index];

                  return Obx(() {
                    final isSelected = selectedContacts.contains(index);
                    return Container(
                      color: isSelected
                          ? Colors.yellow[100]
                          : null, // Highlight if selected
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(contact.name.isNotEmpty
                              ? contact.name[0].toUpperCase()
                              : '?'),
                        ),
                        title: Text(contact.name),
                        subtitle: Text(contact.phone.isNotEmpty
                            ? contact.phone
                            : 'No phone number'),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedContacts.add(index);
                            } else {
                              selectedContacts.remove(index);
                            }
                          },
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
