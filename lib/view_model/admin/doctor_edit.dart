import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isAdmin() async {
  final user = FirebaseAuth.instance.currentUser;

  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(user!.uid)
      .get();

  return doc['role'] == 'admin';
}
