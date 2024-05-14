import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/collection.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:http/http.dart' as http;
import 'package:ps_smoothie_admin/const/common_snackbar.dart';
import 'package:ps_smoothie_admin/get_storage/get_storage_service.dart';

class HomeController extends GetxController {
  int selectTab = 0;
  bool addRecipe = false;
  bool isLoading = false;
  bool isUserLoading = false;
  bool isDeleteLoading = false;

  bool isStatic = false;
  bool isLoad = false;

  int selectedFilter = 0;
  setSelectedFilter(int value) {
    selectedFilter = value;
    update();
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  /// add user
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  ///change password
  TextEditingController adminPassController = TextEditingController();
  TextEditingController adminNPassController = TextEditingController();
  TextEditingController adminNewCPassController = TextEditingController();

  updateSelectTab(int index) {
    selectTab = index;
    update();
  }

  updateAddRecipe(bool value) {
    addRecipe = value;
    update();
  }

  List<Map<String, dynamic>> tabMenu = [
    {'image': AppImage.recipeImage, 'count': '550+', 'name': 'Recipe'},
    {'image': AppImage.userImage, 'count': '5550+', 'name': 'Users'},
  ];

  var smoothie = FirebaseFirestore.instance
      .collection('smoothieCollection')
      .orderBy('time', descending: true)
      .snapshots();

  var staticData =
      FirebaseFirestore.instance.collection('staticData').snapshots();

  List<Map<String, dynamic>> smoothieData = [];
  List<Map<String, dynamic>> smoothieSearchedData = [];

  getRecipeData() async {
    isLoading = true;
    update();

    smoothieData = [];
    smoothieSearchedData = [];

    await smoothie.listen((event) {
      event.docs.forEach((element) {
        smoothieData.add({'data': element.data(), 'id': element.id});
        smoothieSearchedData.add({'data': element.data(), 'id': element.id});
      });
      update();
    });

    await staticData.listen((event) {
      isStatic = event.docs[0].data()["isStatic"];
      update();
    });

    isLoading = false;
    update();
  }

  searchSmoothie(String value) {
    smoothieSearchedData = [];
    if (value.isNotEmpty) {
      smoothieData.forEach((element) {
        if (element['data']['name']
            .toString()
            .toUpperCase()
            .contains(value.toUpperCase())) {
          smoothieSearchedData.add(element);
        }
      });
    } else {
      smoothieSearchedData = smoothieData;
    }
    update();
  }

  ///filter smoothie
  filterSmoothie(int value) {
    smoothieSearchedData = [];

    if (value == 0) {
      smoothieSearchedData = smoothieData;
    } else if (value == 1) {
      smoothieData.forEach((element) {
        if (element['data']['elergic'] == false) {
          smoothieSearchedData.add(element);
        }
      });
    } else {
      smoothieData.forEach((element) {
        if (element['data']['elergic'] == true) {
          smoothieSearchedData.add(element);
        }
      });
    }
    update();
  }

  /// SHOW PROGRESS
  void showProgressDialog() {
    try {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColor.mainColor,
              ),
            ),
          ),
        ),
      );
    } catch (ex) {}
  }

  /// HIDE PROGRESS
  void hideProgressDialog() {
    try {
      Navigator.of(Get.overlayContext!).pop();
    } catch (ex) {}
  }

  updateStaticData(bool value) async {
    showProgressDialog();

    isStatic = value;

    await FirebaseFirestore.instance
        .collection('staticData')
        .doc('staticKey')
        .update({'isStatic': isStatic}).whenComplete(() {
      hideProgressDialog();
    });

    update();
  }

  ///send notification
  sendNotification() async {
    isLoad = true;
    update();

    final data = {
      'to': '/topics/psSmoothie',
      'notification': {
        'body': '${titleController.text.trim()}',
        'title': '${descriptionController.text.trim()}',
      }
    };
    String url = 'https://fcm.googleapis.com/fcm/send';
    try {
      final result = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-type': 'application/json',
          'Authorization':
              'key=AAAAKdd9S8s:APA91bF9gqAgr2O_Cy-FZeDJKdWEGT92uzSgkD43KZkzswcY6ouaiX0c14I6yWCiF1ls00Iz82LYC9lCQn0ydeDspOi-T6nCh8zfGn2sOnvT0Aq7dSHpL3nuvI4IyhUoiY_BhYRMIUyc'
        },
      );
      print("jsonDecode(result.body)=======${jsonDecode(result.body)}");
      await FirebaseFirestore.instance.collection('notification').add({
        'createdAt': DateTime.now(),
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
      });
      Get.back();

      isLoad = false;
      update();

      return jsonDecode(result.body);
    } catch (e) {
      print(e);

      isLoad = false;
      update();
    }
  }

  ///create new user
  void createUser() async {
    isUserLoading = true;
    update();
    try {
      UserCredential userData =
          await kFirebaseAuth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      await userCollection.doc(kFirebaseAuth.currentUser!.uid).set({
        'userName': nameController.text.trim().toString(),
        'userEmail': emailController.text.trim().toString(),
        'userPassword': passwordController.text.trim().toString(),
        'userPhoneNumber': "",
        'userId': kFirebaseAuth.currentUser!.uid,
        'isMember': false,
        'endDate': "",
        'userImage': "",
        'isLogin': true,
        'favourite': [],
        'isUserActive': true,
      });
      CommonSnackBar.showSnackBar(
          context: Get.context!, title: "User Added Successfully!!!");
      Get.back();
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      cPasswordController.clear();
      isUserLoading = false;
      update();
    } on FirebaseAuthException catch (e) {
      isUserLoading = false;
      update();
      if (e.code == "email-already-in-use") {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: "Email is Already in Use");
      } else if (e.code == "weak-password") {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: "Please enter Strong password");
      } else {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: e.message.toString());
      }
      print('ERROR ${e.message}');
      print('ERROR ${e.code}');
    }
    update();
  }

  ///edit user
  void editUser({String? id}) async {
    isUserLoading = true;
    update();
    try {
      await userCollection.doc(id).update({
        'userName': nameController.text.trim().toString(),
        'userEmail': emailController.text.trim().toString(),
        'userPassword': passwordController.text.trim().toString(),
      });
      CommonSnackBar.showSnackBar(
          context: Get.context!, title: "User Updated Successfully!!!");
      Get.back();
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      cPasswordController.clear();
      isUserLoading = false;
      update();
    } on FirebaseAuthException catch (e) {
      isUserLoading = false;
      update();
      if (e.code == "email-already-in-use") {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: "Email is Already in Use");
      } else if (e.code == "weak-password") {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: "Please enter Strong password");
      } else {
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: e.message.toString());
      }
      print('ERROR ${e.message}');
      print('ERROR ${e.code}');
    }
    update();
  }

  ///delete user
  Future<void> deleteUser({String? email, String? password}) async {
    isDeleteLoading = true;
    update();
    try {
      await kFirebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) async {
        await userCollection.doc(kFirebaseAuth.currentUser!.uid).delete();
        await kFirebaseAuth.currentUser!.delete();
        Get.back();
        isDeleteLoading = false;
        update();
        CommonSnackBar.showSnackBar(
            context: Get.context!, title: "User Deleted Successfully!!!");
      });
    } on FirebaseAuthException catch (e) {
      log('e -----1111111111----->>>>>>>> ${e}');
      CommonSnackBar.showSnackBar(context: Get.context!, title: "${e.message}");
      Get.back();
      isDeleteLoading = false;
      update();
    } catch (e) {
      log('e ---------->>>>>>>> ${e}');
      CommonSnackBar.showSnackBar(context: Get.context!, title: "${e}");
      Get.back();
      isDeleteLoading = false;
      update();
    }
  }

  ///change admin password
  Future<void> changePassword() async {
    isLoad = true;
    update();
    try {
      var data = await adminCollection.get();
      data.docs.forEach((element) async {
        if (element['email'] == PreferenceManager.getAdminEmail() &&
            element['password'] == PreferenceManager.getAdminPassword()) {
          await adminCollection.doc(element.id).update({
            'password': adminNPassController.text.trim(),
          });

          // PreferenceManager.setAdminEmail(element['email']);
          PreferenceManager.setAdminPassword(adminNPassController.text.trim());
          Get.back();
          CommonSnackBar.showSnackBar(
              context: Get.context!,
              title: "Admin Password Updated Successfully!!!");
        } else {
          CommonSnackBar.showSnackBar(
              context: Get.context!, title: "Admin Password Not Updated!!!");
        }
      });
      adminPassController.clear();
      adminNPassController.clear();
      adminNewCPassController.clear();
      isLoad = false;
      update();
    } catch (e) {
      CommonSnackBar.showSnackBar(
          context: Get.context!, title: "Something went wrong!!!");
      isLoad = false;
      update();
    }
  }
}
