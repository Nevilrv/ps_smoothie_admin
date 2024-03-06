import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/common_snackbar.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';

class EditRecipeController extends GetxController {
  TextEditingController foodNameController = TextEditingController();
  bool elergic = false;
  String imageurl = '';
  List<List<TextEditingController>> allIngredientsName = [];
  List<List<TextEditingController>> allIngredientsValue = [];
  List<TextEditingController> sizeValue = [];
  HomeController homeController = Get.put(HomeController());
  addNewSizeField() {
    sizeValue.add(TextEditingController());
    allIngredientsName.add([TextEditingController()]);
    allIngredientsValue.add([TextEditingController()]);
    update();
  }

  removeSizeField(int index) {
    sizeValue.removeAt(index);
    allIngredientsName.removeAt(index);
    allIngredientsValue.removeAt(index);
    update();
  }

  addNewNameField(int sizeIndex) {
    allIngredientsName[sizeIndex].add(TextEditingController());
    allIngredientsValue[sizeIndex].add(TextEditingController());
    update();
  }

  removeNewNameField(int sizeIndex, int subIndex) {
    allIngredientsName[sizeIndex].removeAt(subIndex);
    allIngredientsValue[sizeIndex].removeAt(subIndex);
    update();
  }

  Future createFieldData({required Map<String, dynamic> data}) async {
    foodNameController.text = data['name'];
    elergic = data['elergic'];
    imageurl = data['image'];

    for (var i = 0; i < data['size'].length; i++) {
      allIngredientsName.add([TextEditingController()]);
      allIngredientsValue.add([TextEditingController()]);
    }

    for (var i = 0; i < data['size'].length; i++) {
      for (var j = 0; j < data['size'][i]['key'].length; j++) {
        allIngredientsName[i]
            .add(TextEditingController(text: data['size'][i]['key'][j]));
        allIngredientsValue[i]
            .add(TextEditingController(text: data['size'][i]['value'][j]));
      }
    }

    for (var i = 0; i < data['size'].length; i++) {
      sizeValue.add(TextEditingController(text: data['size'][i]['size']));
      removeNewNameField(i, 0);
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

  /// SINGLE BANNER PICKER
  Uint8List? bannerImage;
  String? fileName;
  ImagePicker imagePicker = ImagePicker();

  bannerPickImage() async {
    var result = await imagePicker.pickImage(source: ImageSource.gallery);
    if (result == null) {
      print("No file selected");
    } else {
      bannerImage = await result.readAsBytes();
      fileName = result.name;
      update();

      print('Image pick= = ${result.name}');
    }
    update();
  }

  /// UPLOAD IMAGE TO STORAGE
  Future<String> uploadImageToStorage(
      {String? name, Uint8List? data, BuildContext? context}) async {
    FirebaseStorage firestorage = FirebaseStorage.instance;
    try {
      Reference ref = firestorage.ref('Smoothie').child(name!);
      UploadTask uploadTask =
          ref.putData(data!, SettableMetadata(contentType: 'image/png'));
      TaskSnapshot taskSnapshot = await uploadTask
          .whenComplete(() => print('done'))
          .catchError((error) {
        hideProgressDialog();

        CommonSnackBar.errorBar(
            title: 'Something went wrong...', context: context);
      });

      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      hideProgressDialog();

      print('-----ERROR---${e}');
      return '';
    }
  }

  List<Map<String, dynamic>> sizeData = [];
  Map<String, dynamic> ingredientsData = {};

  updateSmoothieToFirebase(
      {BuildContext? context, required String documentId}) async {
    showProgressDialog();
    if (foodNameController.text.isNotEmpty &&
        allIngredientsName.first.first.text.isNotEmpty &&
        allIngredientsValue.first.first.text.isNotEmpty) {
      try {
        String imageUrl = '';
        if (bannerImage == null) {
          imageUrl = imageurl;
        } else {
          imageUrl =
              await uploadImageToStorage(data: bannerImage, name: fileName);
        }
        List keyList = [];
        List valueList = [];
        Map<String, dynamic> sizeMap = {};
        // size:
        // [
        //   {'key': [], 'size': '', 'value': []},
        //   {'key': [], 'size': '', 'value': []},
        // ];

        for (var i = 0; i < sizeValue.length; i++) {
          keyList = [];
          valueList = [];
          sizeMap = {};
          for (var j = 0; j < allIngredientsName[i].length; j++) {
            keyList.add(allIngredientsName[i][j].text);
            valueList.add(allIngredientsValue[i][j].text);
          }
          log('----keyList----$keyList');
          log('----valueList----$valueList');
          sizeMap = {
            'key': keyList,
            'size': sizeValue[i].text,
            'value': valueList
          };

          log('----sizeMap------$sizeMap');
          sizeData.add(sizeMap);
        }

        log('---------Sizedata----$sizeData');

        if (imageUrl.isNotEmpty) {
          ingredientsData.addAll({
            'name': foodNameController.text,
            'elergic': elergic,
            'image': imageUrl,
            'size': sizeData,
            'time': DateTime.now()
          });
          await FirebaseFirestore.instance
              .collection('smoothieCollection')
              .doc(documentId)
              .update(ingredientsData)
              .whenComplete(() {
            // clearValue();
            CommonSnackBar.successBar(
                title: 'Smoothie Updated Successfully', context: context);

            hideProgressDialog();
          });
        } else {
          hideProgressDialog();

          CommonSnackBar.errorBar(
              title: 'Something went wrong...', context: context);
        }
        print('-----FINAL MAP--------${ingredientsData}');
      } catch (e) {
        hideProgressDialog();
      }
    } else if (foodNameController.text.isEmpty) {
      hideProgressDialog();

      CommonSnackBar.warningBar(context: context, title: 'Enter Food name');
    } else if (bannerImage == null) {
      hideProgressDialog();

      CommonSnackBar.warningBar(context: context, title: 'Enter Food image');
    } else if (allIngredientsName.first.first.text.isEmpty &&
        allIngredientsValue.first.first.text.isEmpty) {
      hideProgressDialog();

      CommonSnackBar.warningBar(
          context: context, title: 'Enter Food ingredients');
    }
    update();
  }
}
