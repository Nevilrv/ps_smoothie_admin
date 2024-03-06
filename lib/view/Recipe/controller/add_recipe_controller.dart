import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/common_snackbar.dart';

class AddRecipeController extends GetxController {
  TextEditingController foodNameController = TextEditingController();
  bool elergic = false;

  updateElergic() {
    elergic = !elergic;
    update();
  }

  List<List<TextEditingController>> allIngredientsName = [
    [TextEditingController()]
  ];
  List<List<TextEditingController>> allIngredientsValue = [
    [TextEditingController()]
  ];
  List<TextEditingController> sizeValue = [TextEditingController()];

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

  /// ========================== OLD =====================================================================

  List<String> shakeSize = [
    '16 OZ',
    '18 OZ',
    '20 OZ',
    '22 OZ',
    '24 OZ',
    '26 OZ',
    '28 OZ',
    '30 OZ',
  ];

  List<String> sizeAdded = [];

  updateSizeAdd({String? value}) {
    sizeAdded.add(value!);
    update();
  }

  /// FOR PAGE VIEW
  PageController pageController = PageController(initialPage: 0);
  ScrollController scrollController = ScrollController();
  int selectedPage = 0;
  updateSelectedPage(int value) {
    selectedPage = value;
    update();
  }

  /// SELECT SIZE OF SHAKE FOR DROPDOWN
  String selectShakeSize = '';
  updateShakeSize(String value) {
    selectShakeSize = value;

    update();
  }

  /// FOR ADD INGREDIENTS
  List<int> sizeCounts = [1, 1, 1, 1, 1, 1, 1, 1];
  List<double> pageViewSize = [55, 55, 55, 55, 55, 55, 55, 55];
  Map<String, dynamic> finalIngredientsData = {};
  Map<String, dynamic> ingredientsData = {};

  List<List<TextEditingController>> ingredientsName = [
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
  ];
  List<List<TextEditingController>> ingredientsValue = [
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
    [TextEditingController()],
  ];

  /// ADD INGREDENT
  incrementParticularIngredients(int sizeCountIndex, BuildContext context) {
    if (ingredientsName[sizeCountIndex].last.text.isNotEmpty) {
      pageViewSize[sizeCountIndex] += 55;

      sizeCounts[sizeCountIndex]++;

      ingredientsName[selectedPage].add(TextEditingController());
      ingredientsValue[selectedPage].add(TextEditingController());
      print('--------INGREDIENT NAME---${ingredientsName}');
      print('--------INGREDIENT VALUE---${ingredientsValue}');
    } else {
      CommonSnackBar.warningBar(title: 'Fill Field First', context: context);
    }
    update();
  }

  /// REMOVE INGREDENT

  removeParticularIngredients(int sizeCountIndex, int particularSizeIndex) {
    sizeCounts[sizeCountIndex]--;
    pageViewSize[sizeCountIndex] -= 55;

    ingredientsName[sizeCountIndex].removeAt(particularSizeIndex);
    ingredientsValue[sizeCountIndex].removeAt(particularSizeIndex);
    print('--------INGREDIENT NAME---${ingredientsName}');
    print('--------INGREDIENT VALUE---${ingredientsValue}');
    update();
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

  /// DATA ADD TO FIRBASE
  uploadDataToFirebase({BuildContext? context}) async {
    showProgressDialog();
    if (foodNameController.text.isNotEmpty &&
        bannerImage != null &&
        ingredientsName.first.first.text.isNotEmpty &&
        ingredientsValue.first.first.text.isNotEmpty) {
      try {
        String imageUrl =
            await uploadImageToStorage(data: bannerImage, name: fileName);
        int j;
        int k;
        for (int i = 0; i < ingredientsName.length; i++) {
          finalIngredientsData.addAll(
            {
              '${shakeSize[i].toString().split(' ').first}': {
                for (j = 0; j < ingredientsName[i].length; j++)
                  '${ingredientsName[i][j].text}':
                      '${ingredientsValue[i][j].text}'
              },
            },
          );
        }

        for (int i = 0; i < sizeAdded.length; i++) {
          for (k = 0; k < finalIngredientsData.length; k++) {
            if (finalIngredientsData.keys.toList()[k] ==
                sizeAdded[i].split(' ').first) {
              ingredientsData.addAll(
                {
                  '${sizeAdded[i].split(' ').first}':
                      finalIngredientsData.values.toList()[k]
                },
              );
            }
          }
        }

        if (imageUrl.isNotEmpty) {
          ingredientsData.addAll({
            'name': foodNameController.text,
            'elergic': elergic,
            'image': imageUrl,
            'size': sizeAdded,
            'time': DateTime.now()
          });
          await FirebaseFirestore.instance
              .collection('smoothieCollection')
              .add(ingredientsData)
              .whenComplete(() {
            clearValue();
            CommonSnackBar.successBar(
                title: 'Smoothie Upload Successfully', context: context);
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
    } else if (ingredientsName.first.first.text.isEmpty &&
        ingredientsValue.first.first.text.isEmpty) {
      hideProgressDialog();

      CommonSnackBar.warningBar(
          context: context, title: 'Enter Food ingredients');
    }
    update();
  }

  List<Map<String, dynamic>> sizeData = [];

  addSmoothieToFirebase({BuildContext? context}) async {
    showProgressDialog();
    if (foodNameController.text.isNotEmpty &&
        bannerImage != null &&
        allIngredientsName.first.first.text.isNotEmpty &&
        allIngredientsValue.first.first.text.isNotEmpty) {
      try {
        String imageUrl =
            await uploadImageToStorage(data: bannerImage, name: fileName);

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
          log('----keyList---$keyList');
          log('----valueList---$valueList');
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
              .add(ingredientsData)
              .whenComplete(() {
            clearValue();
            CommonSnackBar.successBar(
                title: 'Smoothie Upload Successfully', context: context);
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
    } else if (ingredientsName.first.first.text.isEmpty &&
        ingredientsValue.first.first.text.isEmpty) {
      hideProgressDialog();

      CommonSnackBar.warningBar(
          context: context, title: 'Enter Food ingredients');
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

  /// CLEAR VALUE
  clearValue() {
    bannerImage = null;
    selectedPage = 0;
    sizeAdded = [];
    sizeCounts = [1, 1, 1, 1, 1, 1, 1, 1];
    pageViewSize = [55, 55, 55, 55, 55, 55, 55, 55];
    finalIngredientsData = {};
    ingredientsData = {};
    selectShakeSize = '';
    ingredientsName = [
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
    ];
    ingredientsValue = [
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
      [TextEditingController()],
    ];
    allIngredientsName = [
      [TextEditingController()]
    ];
    allIngredientsValue = [
      [TextEditingController()]
    ];
    sizeValue = [TextEditingController()];

    update();
  }
}
