import 'package:aescryptojs/aescryptojs.dart';
import 'package:authentication_task/Screens/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpFeature {
  SignUpFeature._();
  static Future signUp(
    BuildContext context, {
    required String userName,
    required String email,
    required String password,
  }) async {
    var collection = FirebaseFirestore.instance.collection("users");
    var matchedUserNameList =
        await collection.where("userName", isEqualTo: userName).get();

    if (matchedUserNameList.docs.isEmpty) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        collection.doc(value.user?.uid).set({
          "userName": userName,
          "userEmail": email,
          "userPassword": encryptAESCryptoJS(password, value.user!.uid),
        });
        Navigator.pushNamed(context, HomePage.routeName);
      }).onError<FirebaseAuthException>((error, stackTrace) async {
        Fluttertoast.showToast(
            msg: error.message!, gravity: ToastGravity.SNACKBAR);
      }).catchError((error) {});
    } else {
      Fluttertoast.showToast(
          msg: "user name is used", gravity: ToastGravity.SNACKBAR);
    }
  }
}
