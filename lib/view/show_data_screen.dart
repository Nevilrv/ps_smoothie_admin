import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:ps_smoothie_admin/view/Recipe/screen/recipe_screen.dart';
import 'package:ps_smoothie_admin/view/login_screen.dart';
import 'package:ps_smoothie_admin/view/user_screen.dart';

class ShowDataScreen extends StatelessWidget {
  const ShowDataScreen({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...List.generate(
                  controller.tabMenu.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 26 * size),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16 * size),
                        onTap: () {
                          controller.updateSelectTab(index);
                        },
                        child: Container(
                          height: Responsive.isDesktop(context)
                              ? 150
                              : Responsive.isTablet(context)
                                  ? 120
                                  : 100,
                          width: Responsive.isDesktop(context)
                              ? 250
                              : Responsive.isTablet(context)
                                  ? 200
                                  : 150,
                          padding: EdgeInsets.symmetric(
                              horizontal: 9 * size, vertical: 9 * size),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16 * size),
                            border: Border.all(
                                color: controller.selectTab == index
                                    ? AppColor.mainColor
                                    : AppColor.transparentColor),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16 * size),
                              color: controller.selectTab == index
                                  ? AppColor.mainColor
                                  : AppColor.ligthPurpleColor,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  controller.tabMenu[index]['image'],
                                  height:
                                      Responsive.isDesktop(context) ? 70 : 50,
                                  width:
                                      Responsive.isDesktop(context) ? 70 : 50,
                                  color: controller.selectTab == index
                                      ? AppColor.whiteColor
                                      : AppColor.mainColor,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection(index == 0
                                              ? 'smoothieCollection'
                                              : 'user')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  QuerySnapshot<
                                                      Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          var data = snapshot.data?.docs;
                                          return CommonText(
                                            text: '${data!.length}',
                                            fontSize:
                                                Responsive.isDesktop(context)
                                                    ? 23
                                                    : 20,
                                            fontWeight: FontWeight.w700,
                                            color: controller.selectTab == index
                                                ? AppColor.whiteColor
                                                : AppColor.mainColor,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text('Something went wrong'),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: AppColor.mainColor),
                                          );
                                        }
                                      },
                                    ),
                                    CommonText(
                                      text: controller.tabMenu[index]['name'],
                                      fontSize: Responsive.isDesktop(context)
                                          ? 23
                                          : 20,
                                      fontWeight: FontWeight.w400,
                                      color: controller.selectTab == index
                                          ? AppColor.whiteColor
                                          : AppColor.mainColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: Responsive.isDesktop(context) ? 300 : 50,
                    child: CommonTextField(
                      cursorColor: AppColor.mainColor,
                      controller: controller.searchController,
                      enabledBorderColor: AppColor.mainColor,
                      focusedBorderColor: AppColor.mainColor,
                      filledColor: AppColor.ligthPurpleColor,
                      inputTextColor: AppColor.mainColor,
                      textFieldSize: 15,
                      borderRadius: 10,
                      inputTextSize: 15,
                      hintText: 'Search here...',
                      hintTextColor: AppColor.mainColor,
                      onChanged: (value) {
                        controller.searchSmoothie(value);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10 * size),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 50),
                          children: [
                            SizedBox(
                              height: 56,
                              width: 250,
                              child: CommonButton(
                                buttonColor: AppColor.mainColor,
                                radius: 10,
                                onPressed: () {
                                  controller.updateAddRecipe(true);
                                  Get.back();
                                },
                                child: CommonText(
                                  text: 'Upload Single',
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                controller.updateAddRecipe(true);
                                Get.back();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 56,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColor.mainColor,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: CommonText(
                                  text: 'Upload  Excel',
                                  color: AppColor.mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: Responsive.isDesktop(context) ? 70 : 50,
                    width: Responsive.isDesktop(context) ? 70 : 50,
                    decoration: BoxDecoration(
                      color: AppColor.ligthPurpleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.uploadImage,
                          height: Responsive.isDesktop(context) ? 50 : 30,
                          width: Responsive.isDesktop(context) ? 50 : 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10 * size),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(
                              child: CommonText(
                                text: 'Do you really want to Logout?',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 80,
                                      child: CommonButton(
                                        buttonColor: AppColor.mainColor,
                                        radius: 10,
                                        onPressed: () {
                                          Get.offAll(() => MainScreen());
                                        },
                                        child: CommonText(
                                          text: 'Yes',
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 40,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: CommonText(
                                          text: 'No',
                                          color: AppColor.mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    height: Responsive.isDesktop(context) ? 70 : 50,
                    width: Responsive.isDesktop(context) ? 70 : 50,
                    decoration: BoxDecoration(
                      color: AppColor.ligthPurpleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.logout,
                          height: Responsive.isDesktop(context) ? 35 : 25,
                          width: Responsive.isDesktop(context) ? 35 : 25,
                          color: AppColor.mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: Responsive.isDesktop(context)
              ? 35
              : Responsive.isTablet(context)
                  ? 25
                  : 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Static Data",
              style: TextStyle(
                  fontSize: 20,
                  color: AppColor.mainColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Switch(
              value: controller.isStatic,
              onChanged: (value) {
                controller.updateStaticData(value);
              },
              activeColor: AppColor.ligthPurpleColor,
              activeTrackColor: AppColor.mainColor,
            ),
          ],
        ),
        SizedBox(
          height: Responsive.isDesktop(context)
              ? 35
              : Responsive.isTablet(context)
                  ? 25
                  : 15,
        ),
        controller.selectTab == 0
            ? RecipeScreen(
                homeController: controller,
              )
            : UserScreen(
                homeController: controller,
              )
      ],
    );
  }
}
