import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/color.dart';

class HomeController extends GetxController {
  int selectTab = 0;
  bool addRecipe = false;
  bool isLoading = false;

  bool isStatic = false;

  TextEditingController searchController = TextEditingController();

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
}
