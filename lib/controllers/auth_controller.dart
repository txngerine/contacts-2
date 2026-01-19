// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Rxn<User> firebaseUser = Rxn<User>();
//   RxString userRole = ''.obs;
//   RxString username = ''.obs;
//   RxString userEmail = ''.obs;
//   var isPasswordHidden = true.obs;


//   @override
//   void onInit() {
//     super.onInit();
//     firebaseUser.bindStream(_auth.authStateChanges());
//     ever(firebaseUser, _setInitialScreen);
//   }

//   // Set initial screen based on user's role
//   void _setInitialScreen(User? user) async {
//     if (user == null) {
//       await _showMaterialSnackbar('Please login first', '/login');
//     } else {
//       await fetchUserRole();
//       await _showMaterialSnackbar('Welcome back!', '/home');
//     }
//   }


//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }


//   Future<void> fetchUserRole() async {
//   if (firebaseUser.value != null) {
//     try {
//       final userDoc = await _firestore
//           .collection('users')
//           .doc(firebaseUser.value!.uid)
//           .get();
//       userRole.value = userDoc['role'] ?? 'user'; // Default to 'user'
//       username.value = userDoc['username'] ?? 'Guest'; // Default to 'Guest'
//       userEmail.value=userDoc['email']??'non';
//     } catch (e) {
//       await _showMaterialSnackbar('Failed to fetch user details: $e', '/login');
//     }
//   }
// }

//  Future<void> editProfile({
//     required String updatedUsername,
//     required String updatedEmail,
//     String? updatedRole, // Optional, if applicable
//   }) async {
//     if (firebaseUser.value == null) {
//       await _showMaterialSnackbar('User not logged in.', '/login');
//       return;
//     }

//     try {
//       String userId = firebaseUser.value!.uid;

//       // Prepare the updated data
//       Map<String, dynamic> updatedData = {
//         'username': updatedUsername,
//         'email': updatedEmail,
//       };

//       if (updatedRole != null && userRole.value == 'admin') {
//         // Only allow role updates if the user is an admin
//         updatedData['role'] = updatedRole;
//       }

//       // Update the user data in Firestore
//       await _firestore.collection('users').doc(userId).update(updatedData);

//       // Update local observable fields
//       username.value = updatedUsername;
//       userEmail.value = updatedEmail;
//       if (updatedRole != null) userRole.value = updatedRole;

//       await _showMaterialSnackbar('Profile updated successfully.', '/home');
//     } catch (e) {
//       await _showMaterialSnackbar('Failed to update profile: $e', '/home');
//     }
//   }


//   // Show Material Snackbar and navigate after a delay
//   Future<void> _showMaterialSnackbar(String message, String route) async {
//     // Show Material Snackbar with the provided message
//     ScaffoldMessenger.of(Get.context!).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );

//     // Wait for the Snackbar to be visible before navigation
//     await Future.delayed(Duration(seconds: 2));

//     // Perform the navigation after the delay
//     Get.offAllNamed(route);
//   }

//   // Login Method with Error Handling
//   Future<void> login(String email, String password) async {
//     try {
//       if (email.isEmpty || password.isEmpty) {
//         await _showMaterialSnackbar('Email and password cannot be empty.', '/login');
//         return;
//       }

//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       await _showMaterialSnackbar('Login successful.', '/home');
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;

//       // Handle specific FirebaseAuthException cases
//       if (e.code == 'wrong-password') {
//         errorMessage = 'Incorrect password.';
//       } else if (e.code == 'user-not-found') {
//         errorMessage = 'No user found with this email.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'Invalid email format.';
//       } else if (e.code == 'network-request-failed') {
//         errorMessage = 'Network error. Please check your connection.';
//       } else if (e.code == 'credential-too-old') {
//         errorMessage = 'The supplied auth credential is incorrect, malformed, or has expired.';
//       } else {
//         errorMessage = 'An error occurred: ${e.message}';
//       }

//       // Show the error message in the Material Snackbar
//       await _showMaterialSnackbar(errorMessage, '/login');
//     } catch (e) {
//       await _showMaterialSnackbar('Unexpected error occurred: $e', '/login');
//     }
//   }

//   // Login using username (looks up email by username in Firestore)
//   Future<void> loginWithUsername(String username, String password) async {
//     try {
//       if (username.isEmpty || password.isEmpty) {
//         await _showMaterialSnackbar('Username and password cannot be empty.', '/login');
//         return;
//       }

//       // Find user document by username
//       final query = await _firestore
//           .collection('users')
//           .where('username', isEqualTo: username)
//           .limit(1)
//           .get();

//       if (query.docs.isEmpty) {
//         await _showMaterialSnackbar('No user found with this username.', '/login');
//         return;
//       }

//       final userDoc = query.docs.first;
//       final userEmailFromDb = (userDoc.data() as Map<String, dynamic>)['email'] ?? '';

//       if (userEmailFromDb == null || userEmailFromDb.toString().isEmpty) {
//         await _showMaterialSnackbar('No email associated with this username.', '/login');
//         return;
//       }

//       await _auth.signInWithEmailAndPassword(email: userEmailFromDb, password: password);
//       await _showMaterialSnackbar('Login successful.', '/home');
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;

//       if (e.code == 'wrong-password') {
//         errorMessage = 'Incorrect password.';
//       } else if (e.code == 'user-not-found') {
//         errorMessage = 'No user found with this email.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'Invalid email format.';
//       } else if (e.code == 'network-request-failed') {
//         errorMessage = 'Network error. Please check your connection.';
//       } else if (e.code == 'credential-too-old') {
//         errorMessage = 'The supplied auth credential is incorrect, malformed, or has expired.';
//       } else {
//         errorMessage = 'An error occurred: ${e.message}';
//       }

//       await _showMaterialSnackbar(errorMessage, '/login');
//     } catch (e) {
//       await _showMaterialSnackbar('Unexpected error occurred: $e', '/login');
//     }
//   }

//   // Send password reset email
//   Future<void> sendPasswordReset(String email) async {
//     try {
//       if (email.isEmpty) {
//         await _showMaterialSnackbar('Please provide your email.', '/login');
//         return;
//       }

//       if (!GetUtils.isEmail(email)) {
//         await _showMaterialSnackbar('Please enter a valid email.', '/login');
//         return;
//       }

//       await _auth.sendPasswordResetEmail(email: email);
//       await _showMaterialSnackbar('Password reset email sent. Check your inbox.', '/login');
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;
//       if (e.code == 'user-not-found') {
//         errorMessage = 'No user found with this email.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'Invalid email address.';
//       } else if (e.code == 'network-request-failed') {
//         errorMessage = 'Network error. Please check your connection.';
//       } else {
//         errorMessage = 'Failed to send reset email: ${e.message}';
//       }

//       await _showMaterialSnackbar(errorMessage, '/login');
//     } catch (e) {
//       await _showMaterialSnackbar('Unexpected error occurred: $e', '/login');
//     }
//   }

//   Future<void> signup(String email, String password, String role, String username) async {
//   try {
//     if (username.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty) {
//       await _showMaterialSnackbar('All fields are required.', '/signup');
//       return;
//     }

//     if (!GetUtils.isEmail(email)) {
//       await _showMaterialSnackbar('Please enter a valid email.', '/signup');
//       return;
//     }

//     if (password.length < 6) {
//       await _showMaterialSnackbar('Password must be at least 6 characters.', '/signup');
//       return;
//     }

//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     // Store the user data in Firestore
//     await _firestore.collection('users').doc(userCredential.user!.uid).set({
//       'username': username,
//       'email': email,
//       'role': role,
//     });

//     await _showMaterialSnackbar('Signup successful.', '/home');
//   } on FirebaseAuthException catch (e) {
//     String errorMessage;

//     switch (e.code) {
//       case 'email-already-in-use':
//         errorMessage = 'This email is already in use.';
//         break;
//       case 'invalid-email':
//         errorMessage = 'Invalid email format.';
//         break;
//       case 'weak-password':
//         errorMessage = 'Password is too weak.';
//         break;
//       default:
//         errorMessage = 'An error occurred: ${e.message}';
//     }

//     await _showMaterialSnackbar(errorMessage, '/signup');
//   } catch (e) {
//     await _showMaterialSnackbar('Unexpected error occurred: $e', '/signup');
//   }
// }


//   // Logout Method with Error Handling
//   void logout() async {
//     try {
//       await _auth.signOut();
//       await _showMaterialSnackbar('Logout successful.', '/login');
//     } catch (e) {
//       await _showMaterialSnackbar('Failed to log out: $e', '/login');
//     }
//   }

//   // Method to check if the current user is an admin
//   bool get isAdmin {
//     return userRole.value == 'admin';
//   }

//   // Method to change the role of a user (Only admin should have this privilege)
//   Future<void> changeUserRole(String userId, String newRole) async {
//     if (!isAdmin) {
//       await _showMaterialSnackbar('You are not authorized to perform this action.', '/home');
//       return;
//     }

//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'role': newRole,
//       });
//       await _showMaterialSnackbar('User role updated successfully.', '/home');
//     } catch (e) {
//       await _showMaterialSnackbar('Failed to update user role: $e', '/home');
//     }
//   }
//   // Delete Profile Method with Firestore and FirebaseAuth cleanup
// Future<void> deleteProfile() async {
//   if (firebaseUser.value == null) {
//     await _showMaterialSnackbar('User not logged in.', '/login');
//     return;
//   }

//   try {
//     String userId = firebaseUser.value!.uid;

//     // Delete user data from Firestore
//     await _firestore.collection('users').doc(userId).delete();

//     // Delete user account from Firebase Authentication
//     await firebaseUser.value!.delete();

//     await _showMaterialSnackbar('Profile deleted successfully.', '/login');
//   } on FirebaseAuthException catch (e) {
//     // Handle re-authentication requirement
//     if (e.code == 'requires-recent-login') {
//       await _showMaterialSnackbar(
//         'Please log in again before deleting your account.',
//         '/login',
//       );
//     } else {
//       await _showMaterialSnackbar('Failed to delete profile: ${e.message}', '/home');
//     }
//   } catch (e) {
//     await _showMaterialSnackbar('Unexpected error: $e', '/home');
//   }
// }

// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive user state
  final Rxn<User> firebaseUser = Rxn<User>();
  // start empty so app doesn't assume a logged-in user on startup
  final RxString userRole = ''.obs;
  final RxString username = ''.obs;
  final RxString userEmail = ''.obs;
  final RxBool isPasswordHidden = true.obs;
  // Phone auth helpers
  String? _verificationId;
  int? _resendToken;

  // -------------------- LIFECYCLE --------------------

 @override
void onInit() {
  super.onInit();
  firebaseUser.bindStream(_auth.authStateChanges());
  ever(firebaseUser, _onAuthChanged);
}


  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      // If the current user is an anonymous (guest) account that was
      // previously persisted, sign them out so the app shows the login screen.
      if (user.isAnonymous) {
        try {
          await _auth.signOut();
        } catch (e) {
          debugPrint('Failed to sign out anonymous user: $e');
        }
        Get.offAllNamed('/login');
        return;
      }

      await fetchUserData();
      Get.offAllNamed('/home');
    }
  }

  // -------------------- UI HELPERS --------------------

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void _showSnackbar(String message) {
    if (Get.context == null) return;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // -------------------- USER DATA --------------------

  Future<void> fetchUserData() async {
    try {
      final uid = firebaseUser.value!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return;

      final data = doc.data()!;
      userRole.value = data['role'] ?? 'user';
      username.value = data['username'] ?? 'Guest';
      userEmail.value = data['email'] ?? '';
    } catch (e) {
      _showSnackbar('Failed to load user data');
    }
  }

  // -------------------- AUTH --------------------

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Email and password required');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_mapAuthError(e));
    }
  }

  /// ✅ LOGIN WITH USERNAME (FIXED)
  Future<void> loginWithUsername(String inputUsername, String password) async {
    if (inputUsername.isEmpty || password.isEmpty) {
      _showSnackbar('Username and password required');
      return;
    }

    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: inputUsername)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _showSnackbar('Username not found');
        return;
      }

      final email = query.docs.first.data()['email'];
      if (email == null || email.toString().isEmpty) {
        _showSnackbar('No email linked to username');
        return;
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_mapAuthError(e));
    }
  }

  Future<void> signup(
    String email,
    String password,
    String role,
    String usernameInput,
  ) async {
    // username, password and role are required; email is optional
    if (password.isEmpty || role.isEmpty || usernameInput.isEmpty) {
      _showSnackbar('Username, password and role are required');
      return;
    }

    // Ensure username is unique in Firestore
    try {
      final existing = await _firestore
          .collection('users')
          .where('username', isEqualTo: usernameInput)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        _showSnackbar('Username already taken');
        return;
      }
    } catch (e) {
      // Non-fatal; proceed but warn
      _showSnackbar('Failed to validate username uniqueness');
      return;
    }

    // If email is empty, generate a synthetic email based on username
    String emailToUse = email.trim();
    if (emailToUse.isEmpty) {
      final sanitized = usernameInput
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), '_')
          .replaceAll(RegExp(r'_+'), '_');
      final local = sanitized.isEmpty
          ? 'user_${DateTime.now().millisecondsSinceEpoch}'
          : sanitized;
      emailToUse = '$local@korlinks.app';
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': emailToUse,
        'username': usernameInput,
        'role': role,
      });
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_mapAuthError(e));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    if (!GetUtils.isEmail(email)) {
      _showSnackbar('Enter a valid email');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackbar('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_mapAuthError(e));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // -------------------- PROFILE --------------------

  Future<void> editProfile({
    required String updatedUsername,
    required String updatedEmail,
    String? updatedRole,
  }) async {
    if (firebaseUser.value == null) return;

    try {
      final uid = firebaseUser.value!.uid;

      final data = {
        'username': updatedUsername,
        'email': updatedEmail,
      };

      if (updatedRole != null && isAdmin) {
        data['role'] = updatedRole;
      }

      await _firestore.collection('users').doc(uid).update(data);

      username.value = updatedUsername;
      userEmail.value = updatedEmail;
      if (updatedRole != null) userRole.value = updatedRole;

      _showSnackbar('Profile updated');
    } catch (e) {
      _showSnackbar('Profile update failed');
    }
  }

  Future<void> deleteProfile() async {
    try {
      final uid = firebaseUser.value!.uid;

      await _firestore.collection('users').doc(uid).delete();
      await firebaseUser.value!.delete();

      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showSnackbar('Please login again');
      } else {
        _showSnackbar(e.message ?? 'Delete failed');
      }
    }
  }

  // -------------------- PHONE AUTH --------------------

  Future<void> sendPhoneCode(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCred = await _auth.signInWithCredential(credential);
            if (userCred.user != null) await _ensureUserDoc(userCred.user!);
          } catch (_) {
            // ignore sign-in errors from auto retrieval
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          _showSnackbar(_mapAuthError(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _showSnackbar('Verification code sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _showSnackbar('Failed to send verification code');
    }
  }

  Future<void> verifySmsCode(String smsCode) async {
    if (_verificationId == null) {
      _showSnackbar('No verification in progress');
      return;
    }

    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final userCred = await _auth.signInWithCredential(cred);
      if (userCred.user != null) {
        await _ensureUserDoc(userCred.user!);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_mapAuthError(e));
    } catch (e) {
      _showSnackbar('Verification failed');
    }
  }

  Future<void> _ensureUserDoc(User user) async {
    try {
      final ref = _firestore.collection('users').doc(user.uid);
      final doc = await ref.get();
      if (!doc.exists) {
        await ref.set({
          'phone': user.phoneNumber ?? '',
          'username': user.phoneNumber ?? '',
          'role': 'user',
          'email': user.email ?? '',
        });
      }
    } catch (_) {
      // non-fatal: user can still sign in even if doc write fails
    }
  }

  // -------------------- ADMIN --------------------

  bool get isAdmin => userRole.value == 'admin';

  Future<void> changeUserRole(String userId, String newRole) async {
    if (!isAdmin) {
      _showSnackbar('Unauthorized');
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      _showSnackbar('Role updated');
    } catch (e) {
      _showSnackbar('Failed to update role');
    }
  }

  // -------------------- ERROR MAP --------------------

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-not-found':
        return 'User not found';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email';
      case 'weak-password':
        return 'Weak password';
      case 'network-request-failed':
        return 'Network error';
      default:
        return e.message ?? 'Authentication error';
    }
  }
}

