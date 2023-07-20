import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginFeature {
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user!.uid;
      final userDocument =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDocument.data();
      final encryptedPassword = Encryptor.encrypt(uid, password);

      return userData?['userEmail'] == email &&
          userData?['userPassword'] == encryptedPassword;
    } catch (e) {
      if (e is FirebaseAuthException) {
        Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.SNACKBAR);
      }
      return false;
    }
  }
}
