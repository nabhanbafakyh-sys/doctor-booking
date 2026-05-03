import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isAdmin(String clinicId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  final doc = await FirebaseFirestore.instance
      .collection('clinics')
      .doc(clinicId)
      .collection('users')
      .doc(user.uid)
      .get();

  if (!doc.exists) return false;

  return doc.data()?['role'] == 'admin';
}
