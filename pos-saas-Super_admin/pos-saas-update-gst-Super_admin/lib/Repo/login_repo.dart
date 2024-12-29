import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Screen/Dashboard/dashboard.dart';
import '../Screen/Widgets/Constant Data/constant.dart';

final logInProvider = ChangeNotifierProvider((ref) => LogInRepo());

class LogInRepo extends ChangeNotifier {
  String email = '';
  String password = '';

  Future<void> signIn(BuildContext context) async {
    EasyLoading.show(status: 'Logging in...');
    try {
      mainLoginEmail = email;
      mainLoginPassword = password;
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        EasyLoading.showSuccess('Successful');
        // ignore: use_build_context_synchronously
        context.go('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError('Failed with Error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// class LogInRepo extends ChangeNotifier {
//   String email = '';
//   String password = '';
//   bool isLoggedIn = false;
//
//   Future<void> signIn(BuildContext context) async {
//     EasyLoading.show(status: 'Logging in...');
//     try {
//       mainLoginEmail = email;
//       mainLoginPassword = password;
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
//       if (userCredential != null) {
//         isLoggedIn = true;
//         EasyLoading.dismiss();
//         EasyLoading.showSuccess('Successful');
//         notifyListeners(); // Notify listeners that the login state has changed
//       }
//     } on FirebaseAuthException catch (e) {
//       isLoggedIn = false;
//       EasyLoading.dismiss();
//       EasyLoading.showError(e.message.toString());
//       if (e.code == 'user-not-found') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('No user found for that email.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       } else if (e.code == 'wrong-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Wrong password provided for that user.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } catch (e) {
//       isLoggedIn = false;
//       EasyLoading.dismiss();
//       EasyLoading.showError('Failed with Error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
// }


