// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import '../controllers/contact_controller.dart';
// // // import '../controllers/contact_import.dart';

// // // class ContactImportFromVcfView extends StatelessWidget {
// // //   final ContactImportController importController =
// // //       Get.put(ContactImportController());
// // //   final ContactController contactController = Get.find<ContactController>();
// // //   final RxSet<int> selectedContacts = <int>{}.obs;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           'Import Contacts',
// // //           style: TextStyle(color: Colors.black),
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.refresh, color: Colors.black),
// // //             tooltip: 'Clear Cache',
// // //             onPressed: () {
// // //               importController.deviceContacts.clear();
// // //               selectedContacts.clear();
// // //             },
// // //           ),
// // //           Obx(() {
// // //             return importController.deviceContacts.isNotEmpty
// // //                 ? Padding(
// // //                     padding: const EdgeInsets.all(8.0),
// // //                     child: Row(
// // //                       children: [
// // //                         Checkbox(
// // //                           value: selectedContacts.length ==
// // //                               importController.deviceContacts.length,
// // //                           activeColor: Colors.green,
// // //                           onChanged: (bool? value) {
// // //                             if (value == true) {
// // //                               selectedContacts.addAll(List.generate(
// // //                                   importController.deviceContacts.length,
// // //                                   (index) => index));
// // //                             } else {
// // //                               selectedContacts.clear();
// // //                             }
// // //                           },
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   )
// // //                 : SizedBox.shrink();
// // //           }),
// // //           Obx(() {
// // //             return selectedContacts.isNotEmpty
// // //                 ? TextButton(
// // //                     onPressed: () {
// // //                       final selectedCount = selectedContacts.length;
// // //                       for (final index in selectedContacts) {
// // //                         final contact = importController.deviceContacts[index];
// // //                         contact.ownerId = contactController
// // //                             .authController.firebaseUser.value!.uid;
// // //                         contactController.addContact(contact);
// // //                       }
// // //                       selectedContacts.clear();

// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                           content:
// // //                               Text('$selectedCount contacts imported.'),
// // //                           behavior: SnackBarBehavior.floating,
// // //                         ),
// // //                       );
// // //                       Navigator.pop(context);
// // //                     },
// // //                     child: Text(
// // //                       'Import',
// // //                       style: TextStyle(color: Colors.black),
// // //                     ),
// // //                   )
// // //                 : SizedBox.shrink();
// // //           }),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               children: [
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromVcfFile();
// // //                   },
// // //                   icon: Icon(Icons.file_open),
// // //                   label: Text(
// // //                     'Select VCF File',
// // //                     style: TextStyle(color: Colors.black),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 10),
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromCsvFile();
// // //                   },
// // //                   icon: Icon(Icons.table_chart),
// // //                   label: Text(
// // //                     'Select CSV File',
// // //                     style: TextStyle(color: Colors.black),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: Obx(() {
// // //               if (importController.deviceContacts.isEmpty) {
// // //                 return Center(child: Text('No contacts loaded.'));
// // //               }

// // //               return ListView.builder(
// // //                 itemCount: importController.deviceContacts.length,
// // //                 itemBuilder: (context, index) {
// // //                   final contact = importController.deviceContacts[index];

// // //                   return Obx(() {
// // //                     final isSelected = selectedContacts.contains(index);
// // //                     return Container(
// // //                       color: isSelected ? Colors.yellow[100] : null,
// // //                       child: ListTile(
// // //                         leading: CircleAvatar(
// // //                           child: Text(contact.name.isNotEmpty
// // //                               ? contact.name[0].toUpperCase()
// // //                               : '?'),
// // //                         ),
// // //                         title: Text(contact.name),
// // //                         subtitle: Text(contact.phone.isNotEmpty
// // //                             ? contact.phone
// // //                             : 'No phone number'),
// // //                         trailing: Checkbox(
// // //                           value: isSelected,
// // //                           onChanged: (bool? value) {
// // //                             if (value == true) {
// // //                               selectedContacts.add(index);
// // //                             } else {
// // //                               selectedContacts.remove(index);
// // //                             }
// // //                           },
// // //                         ),
// // //                       ),
// // //                     );
// // //                   });
// // //                 },
// // //               );
// // //             }),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }



// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import '../controllers/contact_controller.dart';
// // // import '../controllers/contact_import.dart';

// // // class ContactImportFromVcfView extends StatelessWidget {
// // //   final ContactImportController importController =
// // //       Get.put(ContactImportController());
// // //   final ContactController contactController = Get.find<ContactController>();
// // //   final RxSet<int> selectedContacts = <int>{}.obs;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           'Import Contacts',
// // //           style: TextStyle(color: Colors.black),
// // //         ),
// // //         actions: [
// // //           // Clear imported contacts
// // //           IconButton(
// // //             icon: Icon(Icons.refresh, color: Colors.black),
// // //             tooltip: 'Clear Imported Contacts',
// // //             onPressed: () {
// // //               importController.deviceContacts.clear();
// // //               selectedContacts.clear();
// // //             },
// // //           ),

// // //           // Select all checkbox
// // //           Obx(() {
// // //             return importController.deviceContacts.isNotEmpty
// // //                 ? Padding(
// // //                     padding: const EdgeInsets.all(8.0),
// // //                     child: Checkbox(
// // //                       value: selectedContacts.length ==
// // //                           importController.deviceContacts.length,
// // //                       activeColor: Colors.green,
// // //                       onChanged: (bool? value) {
// // //                         if (value == true) {
// // //                           selectedContacts.addAll(List.generate(
// // //                               importController.deviceContacts.length,
// // //                               (index) => index));
// // //                         } else {
// // //                           selectedContacts.clear();
// // //                         }
// // //                       },
// // //                     ),
// // //                   )
// // //                 : SizedBox.shrink();
// // //           }),

// // //           // Import button
// // //           Obx(() {
// // //             return selectedContacts.isNotEmpty
// // //                 ? TextButton(
// // //                     onPressed: () {
// // //                       final selectedCount = selectedContacts.length;
// // //                       for (final index in selectedContacts) {
// // //                         final contact = importController.deviceContacts[index];
// // //                         contact.ownerId =
// // //                             contactController.authController.firebaseUser.value!.uid;
// // //                         contactController.addContact(contact);
// // //                       }
// // //                       selectedContacts.clear();

// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                           content: Text('$selectedCount contacts imported.'),
// // //                           behavior: SnackBarBehavior.floating,
// // //                         ),
// // //                       );
// // //                       Navigator.pop(context);
// // //                     },
// // //                     child: Text(
// // //                       'Import',
// // //                       style: TextStyle(color: Colors.black),
// // //                     ),
// // //                   )
// // //                 : SizedBox.shrink();
// // //           }),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               children: [
// // //                 // VCF import button
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromVcfFile();
// // //                   },
// // //                   icon: Icon(Icons.file_open),
// // //                   label: Text(
// // //                     'Select VCF File',
// // //                     style: TextStyle(color: Colors.black),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 10),
// // //                 // CSV import button
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromCsvFile();
// // //                   },
// // //                   icon: Icon(Icons.table_chart),
// // //                   label: Text(
// // //                     'Select CSV File',
// // //                     style: TextStyle(color: Colors.black),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           // Display imported contacts only
// // //           Expanded(
// // //             child: Obx(() {
// // //               if (importController.deviceContacts.isEmpty) {
// // //                 return Center(child: Text('No contacts loaded.'));
// // //               }

// // //               return ListView.builder(
// // //                 itemCount: importController.deviceContacts.length,
// // //                 itemBuilder: (context, index) {
// // //                   final contact = importController.deviceContacts[index];

// // //                   return Obx(() {
// // //                     final isSelected = selectedContacts.contains(index);
// // //                     return Container(
// // //                       color: isSelected ? Colors.yellow[100] : null,
// // //                       child: ListTile(
// // //                         leading: CircleAvatar(
// // //                           child: Text(contact.name.isNotEmpty
// // //                               ? contact.name[0].toUpperCase()
// // //                               : '?'),
// // //                         ),
// // //                         title: Text(contact.name),
// // //                         subtitle: Text(contact.phone.isNotEmpty
// // //                             ? contact.phone
// // //                             : 'No phone number'),
// // //                         trailing: Checkbox(
// // //                           value: isSelected,
// // //                           onChanged: (bool? value) {
// // //                             if (value == true) {
// // //                               selectedContacts.add(index);
// // //                             } else {
// // //                               selectedContacts.remove(index);
// // //                             }
// // //                           },
// // //                         ),
// // //                       ),
// // //                     );
// // //                   });
// // //                 },
// // //               );
// // //             }),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }


// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import '../controllers/contact_controller.dart';
// // // import '../controllers/contact_import.dart';

// // // class ContactImportFromVcfView extends StatelessWidget {
// // //   final ContactImportController importController = Get.put(ContactImportController());
// // //   final ContactController contactController = Get.find<ContactController>();
// // //   final RxSet<int> selectedContacts = <int>{}.obs;

// // //   ContactImportFromVcfView({super.key});

// // //   void importSelectedContacts(BuildContext context) {
// // //     final count = selectedContacts.length;
// // //     for (final index in selectedContacts) {
// // //       final contact = importController.deviceContacts[index]; // these are imported contacts
// // //       contact.ownerId = contactController.authController.firebaseUser.value!.uid;
// // //       contactController.addContact(contact);
// // //     }
// // //     selectedContacts.clear();

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text('$count contacts imported successfully.'),
// // //         behavior: SnackBarBehavior.floating,
// // //       ),
// // //     );

// // //     Navigator.pop(context);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
// // //         actions: [
// // //           // Select All
// // //           Obx(() {
// // //             final contacts = importController.deviceContacts;
// // //             if (contacts.isEmpty) return const SizedBox.shrink();
// // //             return Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Checkbox(
// // //                 value: selectedContacts.length == contacts.length,
// // //                 onChanged: (value) {
// // //                   if (value == true) {
// // //                     selectedContacts.addAll(List.generate(contacts.length, (i) => i));
// // //                   } else {
// // //                     selectedContacts.clear();
// // //                   }
// // //                 },
// // //               ),
// // //             );
// // //           }),

// // //           // Import Button
// // //           Obx(() {
// // //             if (selectedContacts.isEmpty) return const SizedBox.shrink();
// // //             return TextButton(
// // //               onPressed: () => importSelectedContacts(context),
// // //               child: const Text('Import', style: TextStyle(color: Colors.black)),
// // //             );
// // //           }),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               children: [
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromVcfFile();
// // //                   },
// // //                   icon: const Icon(Icons.file_open),
// // //                   label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.deviceContacts.clear();
// // //                     await importController.importContactsFromCsvFile();
// // //                   },
// // //                   icon: const Icon(Icons.table_chart),
// // //                   label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: Obx(() {
// // //               final contacts = importController.deviceContacts;
// // //               if (contacts.isEmpty) {
// // //                 return const Center(child: Text('No contacts loaded.'));
// // //               }

// // //               return ListView.builder(
// // //                 itemCount: contacts.length,
// // //                 itemBuilder: (context, index) {
// // //                   final contact = contacts[index];
// // //                   final isSelected = selectedContacts.contains(index);

// // //                   return Container(
// // //                     color: isSelected ? Colors.yellow[100] : null,
// // //                     child: ListTile(
// // //                       leading: CircleAvatar(
// // //                         child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
// // //                       ),
// // //                       title: Text(contact.name),
// // //                       subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
// // //                       trailing: Checkbox(
// // //                         value: isSelected,
// // //                         onChanged: (value) {
// // //                           if (value == true) {
// // //                             selectedContacts.add(index);
// // //                           } else {
// // //                             selectedContacts.remove(index);
// // //                           }
// // //                         },
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               );
// // //             }),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }


// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import '../controllers/contact_controller.dart';
// // // import '../controllers/contact_import.dart';

// // // class ContactImportFromVcfView extends StatelessWidget {
// // //   final ContactImportController importController = Get.put(ContactImportController());
// // //   final ContactController contactController = Get.find<ContactController>();
// // //   final RxSet<int> selectedContacts = <int>{}.obs;

// // //   ContactImportFromVcfView({super.key});

// // //   void importSelectedContacts(BuildContext context) {
// // //     final count = selectedContacts.length;
// // //     for (final index in selectedContacts) {
// // //       final contact = importController.importedContacts[index]; // Use importedContacts
// // //       contact.ownerId = contactController.authController.firebaseUser.value!.uid;
// // //       contactController.addContact(contact);
// // //     }
// // //     selectedContacts.clear();

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text('$count contacts imported successfully.'),
// // //         behavior: SnackBarBehavior.floating,
// // //       ),
// // //     );

// // //     Navigator.pop(context);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
// // //         actions: [
// // //           // Select All
// // //           Obx(() {
// // //             final contacts = importController.importedContacts; // <-- importedContacts
// // //             if (contacts.isEmpty) return const SizedBox.shrink();
// // //             return Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Checkbox(
// // //                 value: selectedContacts.length == contacts.length,
// // //                 onChanged: (value) {
// // //                   if (value == true) {
// // //                     selectedContacts.addAll(List.generate(contacts.length, (i) => i));
// // //                   } else {
// // //                     selectedContacts.clear();
// // //                   }
// // //                 },
// // //               ),
// // //             );
// // //           }),

// // //           // Import Button
// // //           Obx(() {
// // //             if (selectedContacts.isEmpty) return const SizedBox.shrink();
// // //             return TextButton(
// // //               onPressed: () => importSelectedContacts(context),
// // //               child: const Text('Import', style: TextStyle(color: Colors.black)),
// // //             );
// // //           }),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               children: [
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.importedContacts.clear(); // clear importedContacts
// // //                     await importController.importContactsFromVcfFile();
// // //                   },
// // //                   icon: const Icon(Icons.file_open),
// // //                   label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 ElevatedButton.icon(
// // //                   onPressed: () async {
// // //                     importController.importedContacts.clear(); // clear importedContacts
// // //                     await importController.importContactsFromCsvFile();
// // //                   },
// // //                   icon: const Icon(Icons.table_chart),
// // //                   label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: Obx(() {
// // //               final contacts = importController.importedContacts; // <-- importedContacts
// // //               if (contacts.isEmpty) {
// // //                 return const Center(child: Text('No contacts loaded.'));
// // //               }

// // //               return ListView.builder(
// // //                 itemCount: contacts.length,
// // //                 itemBuilder: (context, index) {
// // //                   final contact = contacts[index];
// // //                   final isSelected = selectedContacts.contains(index);

// // //                   return Container(
// // //                     color: isSelected ? Colors.yellow[100] : null,
// // //                     child: ListTile(
// // //                       leading: CircleAvatar(
// // //                         child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
// // //                       ),
// // //                       title: Text(contact.name),
// // //                       subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
// // //                       trailing: Checkbox(
// // //                         value: isSelected,
// // //                         onChanged: (value) {
// // //                           if (value == true) {
// // //                             selectedContacts.add(index);
// // //                           } else {
// // //                             selectedContacts.remove(index);
// // //                           }
// // //                         },
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               );
// // //             }),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../controllers/contact_controller.dart';
// // import '../controllers/contact_import.dart';

// // class ContactImportFromVcfView extends StatelessWidget {
// //   final ContactImportController importController = Get.put(ContactImportController());
// //   final ContactController contactController = Get.find<ContactController>();
// //   final RxSet<int> selectedContacts = <int>{}.obs;

// //   ContactImportFromVcfView({super.key});

// //   /// Import selected contacts into user's contact list
// //   void importSelectedContacts(BuildContext context) {
// //     final count = selectedContacts.length;
// //     for (final index in selectedContacts) {
// //       final contact = importController.importedContacts[index];
// //       contact.ownerId = contactController.authController.firebaseUser.value!.uid;
// //       contactController.addContact(contact);
// //     }
// //     selectedContacts.clear();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('$count contacts imported successfully.'),
// //         behavior: SnackBarBehavior.floating,
// //       ),
// //     );

// //     Navigator.pop(context);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
// //         actions: [
// //           // Select All checkbox
// //           Obx(() {
// //             final contacts = importController.importedContacts;
// //             if (contacts.isEmpty) return const SizedBox.shrink();
// //             return Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Checkbox(
// //                 value: selectedContacts.length == contacts.length,
// //                 onChanged: (value) {
// //                   if (value == true) {
// //                     selectedContacts.addAll(List.generate(contacts.length, (i) => i));
// //                   } else {
// //                     selectedContacts.clear();
// //                   }
// //                 },
// //               ),
// //             );
// //           }),
// //           // Import button
// //           Obx(() {
// //             if (selectedContacts.isEmpty) return const SizedBox.shrink();
// //             return TextButton(
// //               onPressed: () => importSelectedContacts(context),
// //               child: const Text('Import', style: TextStyle(color: Colors.black)),
// //             );
// //           }),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               children: [
// //                 ElevatedButton.icon(
// //                   onPressed: () async {
// //                     importController.importedContacts.clear();
// //                     await importController.importContactsFromVcfFile();
// //                   },
// //                   icon: const Icon(Icons.file_open),
// //                   label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 ElevatedButton.icon(
// //                   onPressed: () async {
// //                     importController.importedContacts.clear();
// //                     await importController.importContactsFromCsvFile();
// //                   },
// //                   icon: const Icon(Icons.table_chart),
// //                   label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Obx(() {
// //               final contacts = importController.importedContacts;
// //               if (contacts.isEmpty) {
// //                 return const Center(child: Text('No contacts loaded.'));
// //               }

// //               return ListView.builder(
// //                 itemCount: contacts.length,
// //                 itemBuilder: (context, index) {
// //                   final contact = contacts[index];
// //                   final isSelected = selectedContacts.contains(index);

// //                   return Container(
// //                     color: isSelected ? Colors.yellow[100] : null,
// //                     child: ListTile(
// //                       leading: CircleAvatar(
// //                         child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
// //                       ),
// //                       title: Text(contact.name),
// //                       subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
// //                       trailing: Checkbox(
// //                         value: isSelected,
// //                         onChanged: (value) {
// //                           if (value == true) {
// //                             selectedContacts.add(index);
// //                           } else {
// //                             selectedContacts.remove(index);
// //                           }
// //                         },
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../controllers/contact_controller.dart';
// // import '../controllers/contact_import.dart';

// // class ContactImportFromVcfView extends StatelessWidget {
// //   ContactImportFromVcfView({super.key});

// //   final ContactImportController importController = Get.put(ContactImportController());
// //   final ContactController contactController = Get.find<ContactController>();
// //   final RxSet<int> selectedContacts = <int>{}.obs;

// //   void importSelectedContacts(BuildContext context) {
// //     final count = selectedContacts.length;
// //     for (final index in selectedContacts) {
// //       final contact = importController.importedContacts[index];
// //       contact.ownerId = contactController.authController.firebaseUser.value!.uid;
// //       contactController.addContact(contact);
// //     }
// //     selectedContacts.clear();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('$count contacts imported successfully.'),
// //         behavior: SnackBarBehavior.floating,
// //       ),
// //     );

// //     Navigator.pop(context);
// //   }

// //   Future<void> _importFromVcf() async {
// //     importController.importedContacts.clear();
// //     selectedContacts.clear();
// //     await importController.importContactsFromVcfFile();
// //   }

// //   Future<void> _importFromCsv() async {
// //     importController.importedContacts.clear();
// //     selectedContacts.clear();
// //     await importController.importContactsFromCsvFile();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
// //         actions: [
// //           // Select All Checkbox
// //           Obx(() {
// //             final contacts = importController.importedContacts;
// //             if (contacts.isEmpty) return const SizedBox.shrink();

// //             // Keep selectedContacts valid
// //             selectedContacts.retainWhere((index) => index < contacts.length);

// //             return Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Checkbox(
// //                 value: contacts.isNotEmpty && selectedContacts.length == contacts.length,
// //                 onChanged: (value) {
// //                   if (value == true) {
// //                     selectedContacts.value = Set.from(List.generate(contacts.length, (i) => i));
// //                   } else {
// //                     selectedContacts.clear();
// //                   }
// //                 },
// //               ),
// //             );
// //           }),

// //           // Import Button
// //           Obx(() {
// //             if (selectedContacts.isEmpty) return const SizedBox.shrink();
// //             return TextButton(
// //               onPressed: () => importSelectedContacts(context),
// //               child: const Text('Import', style: TextStyle(color: Colors.black)),
// //             );
// //           }),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Import Buttons
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               children: [
// //                 ElevatedButton.icon(
// //                   onPressed: _importFromVcf,
// //                   icon: const Icon(Icons.file_open),
// //                   label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 ElevatedButton.icon(
// //                   onPressed: _importFromCsv,
// //                   icon: const Icon(Icons.table_chart),
// //                   label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // Contact List
// //           Expanded(
// //             child: Obx(() {
// //               final contacts = importController.importedContacts;
// //               if (contacts.isEmpty) return const Center(child: Text('No contacts loaded.'));

// //               return ListView.builder(
// //                 itemCount: contacts.length,
// //                 itemBuilder: (context, index) {
// //                   final contact = contacts[index];
// //                   final isSelected = selectedContacts.contains(index);

// //                   return Container(
// //                     color: isSelected ? Colors.yellow[100] : null,
// //                     child: ListTile(
// //                       leading: CircleAvatar(
// //                         child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
// //                       ),
// //                       title: Text(contact.name),
// //                       subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
// //                       trailing: Checkbox(
// //                         value: isSelected,
// //                         onChanged: (value) {
// //                           if (value == true) {
// //                             selectedContacts.add(index);
// //                           } else {
// //                             selectedContacts.remove(index);
// //                           }
// //                         },
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/contact_controller.dart';
// import '../controllers/contact_import.dart';

// class ContactImportFromVcfView extends StatelessWidget {
//   ContactImportFromVcfView({super.key});

//   final ContactImportController importController = Get.put(ContactImportController());
//   final ContactController contactController = Get.find<ContactController>();
//   final RxSet<int> selectedContacts = <int>{}.obs;

//   void importSelectedContacts(BuildContext context) {
//     final count = selectedContacts.length;
//     for (final index in selectedContacts) {
//       final contact = importController.importedContacts[index];
//       contact.ownerId = contactController.authController.firebaseUser.value!.uid;
//       contactController.addContact(contact);
//     }
//     selectedContacts.clear();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$count contacts imported successfully.'),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );

//     Navigator.pop(context);
//   }

//   Future<void> _importFromVcf() async {
//     importController.importedContacts.clear();
//     selectedContacts.clear();
//     await importController.importContactsFromVcfFile();
//   }

//   Future<void> _importFromCsv() async {
//     importController.importedContacts.clear();
//     selectedContacts.clear();
//     await importController.importContactsFromCsvFile();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         actions: [
//           Obx(() {
//             final contacts = importController.importedContacts;
//             if (contacts.isEmpty) return const SizedBox.shrink();

//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Select All Checkbox
//                 Checkbox(
//                   value: contacts.isNotEmpty && selectedContacts.length == contacts.length,
//                   onChanged: (value) {
//                     if (value == true) {
//                       selectedContacts.value = Set.from(List.generate(contacts.length, (i) => i));
//                     } else {
//                       selectedContacts.clear();
//                     }
//                   },
//                 ),
//                 // Import Button
//                 if (selectedContacts.isNotEmpty)
//                   TextButton(
//                     onPressed: () => importSelectedContacts(context),
//                     child: const Text('Import', style: TextStyle(color: Colors.black)),
//                   ),
//               ],
//             );
//           }),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Import Buttons
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _importFromVcf,
//                   icon: const Icon(Icons.file_open),
//                   label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: _importFromCsv,
//                   icon: const Icon(Icons.table_chart),
//                   label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
//                 ),
//               ],
//             ),
//           ),

//           // Contact List
//           Expanded(
//             child: Obx(() {
//               final contacts = importController.importedContacts;
//               if (contacts.isEmpty) return const Center(child: Text('No contacts loaded.'));

//               return ListView.builder(
//                 itemCount: contacts.length,
//                 itemBuilder: (context, index) {
//                   final contact = contacts[index];
//                   final isSelected = selectedContacts.contains(index);

//                   return Container(
//                     color: isSelected ? Colors.yellow[100] : null,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
//                       ),
//                       title: Text(contact.name),
//                       subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
//                       trailing: Checkbox(
//                         value: isSelected,
//                         onChanged: (value) {
//                           if (value == true) {
//                             selectedContacts.add(index);
//                           } else {
//                             selectedContacts.remove(index);
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../controllers/contact_import.dart';

class ContactImportFromVcfView extends StatelessWidget {
  ContactImportFromVcfView({super.key});

  final ContactImportController importController = Get.put(ContactImportController());
  final ContactController contactController = Get.find<ContactController>();
  final RxSet<int> selectedContacts = <int>{}.obs;

  void importSelectedContacts(BuildContext context) {
    final count = selectedContacts.length;
    for (final index in selectedContacts) {
      final contact = importController.importedContacts[index];
      contact.ownerId = contactController.authController.firebaseUser.value!.uid;
      contactController.addContact(contact);
    }
    selectedContacts.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count contacts imported successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _importFromVcf() async {
    importController.importedContacts.clear();
    selectedContacts.clear();
    await importController.importContactsFromVcfFile();
  }

  Future<void> _importFromCsv() async {
    importController.importedContacts.clear();
    selectedContacts.clear();
    await importController.importContactsFromCsvFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imported Contacts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Obx(() {
            final contacts = importController.importedContacts;
            if (contacts.isEmpty) return const SizedBox.shrink();

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Select All Checkbox
                Checkbox(
                  value: contacts.isNotEmpty && selectedContacts.length == contacts.length,
                  onChanged: (value) {
                    if (value == true) {
                      selectedContacts.value = Set.from(List.generate(contacts.length, (i) => i));
                    } else {
                      selectedContacts.clear();
                    }
                  },
                  checkColor: Colors.black,
                  fillColor: MaterialStateProperty.all(Colors.yellow),
                ),
                // Import Button
                if (selectedContacts.isNotEmpty)
                  TextButton(
                    onPressed: () => importSelectedContacts(context),
                    child: const Text('Import', style: TextStyle(color: Colors.black)),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Import Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _importFromVcf,
                  icon: const Icon(Icons.file_open),
                  label: const Text('Select VCF File', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _importFromCsv,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Select CSV File', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),

          // Contact List
          Expanded(
            child: Obx(() {
              final contacts = importController.importedContacts;
              if (contacts.isEmpty) return const Center(child: Text('No contacts loaded.'));

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];

                  return Obx(() {
                    final isSelected = selectedContacts.contains(index);

                    return Container(
                      color: isSelected ? Colors.yellow[100] : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?'),
                        ),
                        title: Text(contact.name),
                        subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            if (value == true) {
                              selectedContacts.add(index);
                            } else {
                              selectedContacts.remove(index);
                            }
                          },
                          checkColor: Colors.black, // tick color
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.yellow; // background when checked
                            }
                            return Colors.grey.shade200; // background when unchecked
                          }),
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
