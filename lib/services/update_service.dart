// import 'package:in_app_update/in_app_update.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// class UpdateService extends GetxService {
//   static const updateCheckInterval = Duration(hours: 24);
//   DateTime? lastUpdateCheck;

//   Future<void> checkForUpdate({bool isForce = false}) async {
//     try {
//       final now = DateTime.now();
      
//       // Skip if we checked recently and this isn't a forced check
//       if (!isForce && 
//           lastUpdateCheck != null && 
//           now.difference(lastUpdateCheck!).inHours < 24) {
//         return;
//       }

//       lastUpdateCheck = now;

//       // Check for available updates
//       final updateInfo = await InAppUpdate.checkForUpdate();
      
//       if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
//         if (updateInfo.immediateUpdateAllowed) {
//           // Force update required
//           await InAppUpdate.performImmediateUpdate();
//         } else if (updateInfo.flexibleUpdateAllowed) {
//           // Optional update - show snackbar
//           _showUpdateDialog(isRequired: false);
//         }
//       }
//     } catch (e) {
//       print('Update check error: $e');
//     }
//   }

//   void _showUpdateDialog({required bool isRequired}) {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('Update Available'),
//         content: const Text(
//           'A new version of KorLinks is available. Please update to the latest version for the best experience.',
//         ),
//         actions: [
//           if (!isRequired)
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text('Later'),
//             ),
//           TextButton(
//             onPressed: () async {
//               Get.back();
//               try {
//                 await InAppUpdate.startFlexibleUpdate();
//               } catch (e) {
//                 print('Update error: $e');
//               }
//             },
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//       barrierDismissible: !isRequired,
//     );
//   }

//   // Complete flexible update if pending
//   Future<void> completeFlexibleUpdate() async {
//     try {
//       await InAppUpdate.completeFlexibleUpdate();
//     } catch (e) {
//       print('Complete update error: $e');
//     }
//   }
// }
