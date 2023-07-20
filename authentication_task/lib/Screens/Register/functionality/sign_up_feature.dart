import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpFeature {
  SignUpFeature._();
  static Future<bool> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final collection = FirebaseFirestore.instance.collection("users");
      final matchedUserNameList =
          await collection.where("userName", isEqualTo: userName).get();
      if (matchedUserNameList.docs.isEmpty) {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final uid = userCredential.user?.uid;
        collection.doc(uid).set({
          "userName": userName,
          "userEmail": email,
          "userPassword": Encryptor.encrypt(uid!, password),
        });
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "user name is used", gravity: ToastGravity.SNACKBAR);
        return false;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        Fluttertoast.showToast(msg: e.message.toString(), gravity: ToastGravity.SNACKBAR);
      }
      return false;
    }
  }
}
