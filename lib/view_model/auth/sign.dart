// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthVM with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> registerUser({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     try {
//       // Step 1: Create user
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(
//             email: email.trim(),
//             password: password.trim(),
//           );

//       String uid = userCredential.user!.uid;

//       // Step 2: Save extra data (username)
//       await _firestore.collection('users').doc(uid).set({
//         'username': username,
//         'email': email,
//         'uid': uid,
//         'createdAt': Timestamp.now(),
//       });
//     } catch (e) {
//       debugPrint("Error: $e");
//       rethrow;
//     }
//   }

//   Future<void> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       throw e.message ?? "Login failed";
//     } catch (e) {
//       throw "Something went wrong";
//     }
//   }
// }
