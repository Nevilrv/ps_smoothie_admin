import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/common_snackbar.dart';

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// SHOW PROGRESS
  void showProgressDialog() {
    try {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColor.mainColor,
            ),
          ),
        ),
      );
    } catch (ex) {
      log('hideProgressDialog--$ex');
    }
  }

  /// HIDE PROGRESS

  void hideProgressDialog() {
    try {
      Navigator.of(Get.overlayContext!).pop();
    } catch (ex) {
      log('hideProgressDialog--$ex');
    }
  }

  /// LOGIN METHOD

  Future<bool> logInMethod(
      {required String email,
      required String password,
      required BuildContext context}) async {
    showProgressDialog();
    try {
      await kFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      update();

      return true;
    } on FirebaseAuthException catch (e) {
      hideProgressDialog();

      if (e.code == 'network-request-failed') {
        print('ERROR CREATE ON SIGN IN TIME == No Internet Connection.');

        CommonSnackBar.showSnackBar(
            context: context, title: "No Internet Connection.");
      } else if (e.code == 'too-many-requests') {
        print(
            'ERROR CREATE ON SIGN IN TIME == Too many attempts please try later');
        CommonSnackBar.showSnackBar(
            context: context, title: "Too many attempts please try later.");
      } else if (e.code == 'user-not-found') {
        print('ERROR CREATE ON SIGN IN TIME == No user found for that email.');

        CommonSnackBar.showSnackBar(
            context: context, title: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print(
            'ERROR CREATE ON SIGN IN TIME == The password is invalid for the given email.');
        CommonSnackBar.showSnackBar(
            context: context,
            title: "The password is invalid for the given email.");
      } else if (e.code == 'invalid-email') {
        print(
            'ERROR CREATE ON SIGN IN TIME == The email address is not valid.');
        CommonSnackBar.showSnackBar(
            context: context, title: "The email address is not valid.");
      } else if (e.code == 'user-disabled') {
        print(
            'ERROR CREATE ON SIGN IN TIME ==  The user corresponding to the given email has been disabled.');
        CommonSnackBar.showSnackBar(
            context: context,
            title:
                "The user corresponding to the given email has been disabled.");
      } else {
        print('ERROR CREATE ON SIGN IN TIME ==  Something went to Wrong.');
        CommonSnackBar.showSnackBar(
            context: context, title: "Something went to wrong.");
      }
      update();

      return false;
    }
  }
}
