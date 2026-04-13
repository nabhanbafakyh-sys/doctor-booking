import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signin(String email, String password) async {
  await auth.signInWithEmailAndPassword(email: email, password: password);
}
