import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/collection.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:ps_smoothie_admin/get_storage/get_storage_service.dart';
import 'package:ps_smoothie_admin/view/Menu/help_center_screen.dart';
import 'package:ps_smoothie_admin/view/Recipe/screen/recipe_screen.dart';
import 'package:ps_smoothie_admin/view/login_screen.dart';
import 'package:ps_smoothie_admin/view/user_screen.dart';

class ShowDataScreen extends StatelessWidget {
  ShowDataScreen({
    super.key,
    required this.controller,
  });

  final HomeController controller;
  final _formKey = GlobalKey<FormState>();

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
            Image.asset(
              AppImage.logoImage,
              height: 147,
              width: 147,
            ),
            Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(10 * size),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 50),
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
                height: Responsive.isDesktop(context) ? 50 : 45,
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
                      height: Responsive.isDesktop(context) ? 45 : 30,
                      width: Responsive.isDesktop(context) ? 50 : 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            PopupMenuButton<int>(
              splashRadius: 20,
              offset: Offset(0, 15),
              constraints: BoxConstraints(minWidth: 300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              position: PopupMenuPosition.under,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColor.ligthPurpleColor),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, color: AppColor.mainColor),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColor.transparentColor,
                        backgroundImage: AssetImage(
                          AppImage.logoImage,
                        )),
                  ],
                ),
              ),
              onSelected: (value) async {
                if (value == 0) {
                  changePasswordDialog(context);
                } else if (value == 1) {
                  Get.to(() => HelpCenterScreen(),
                      curve: Curves.easeIn,
                      transition: Transition.rightToLeft,
                      duration: Duration(microseconds: 500));
                } else {
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
                                        PreferenceManager.getClear();
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
                                        borderRadius: BorderRadius.circular(10),
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
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: CommonText(
                      text: "Change Password",
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w900,
                    ),
                    value: 0,
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: CommonText(
                      text: "Help Center",
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w900,
                    ),
                    value: 1,
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: CommonText(
                      text: "Log Out",
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w900,
                    ),
                    value: 2,
                  ),
                ];
              },
            ),
          ],
        ),
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
            // Row(
            //   children: [
            //     InkWell(
            //       borderRadius: BorderRadius.circular(10 * size),
            //       onTap: () {
            //
            //       },
            //       child: Container(
            //         height: Responsive.isDesktop(context) ? 70 : 50,
            //         width: Responsive.isDesktop(context) ? 70 : 50,
            //         decoration: BoxDecoration(
            //           color: AppColor.ligthPurpleColor,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(
            //               AppImage.logout,
            //               height: Responsive.isDesktop(context) ? 35 : 25,
            //               width: Responsive.isDesktop(context) ? 35 : 25,
            //               color: AppColor.mainColor,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        // Row(
        //   // mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     // Text(
        //     //   "Static Data",
        //     //   style: TextStyle(
        //     //       fontSize: 20,
        //     //       color: AppColor.mainColor,
        //     //       fontWeight: FontWeight.bold),
        //     // ),
        //     // SizedBox(width: 10),
        //     // Switch(
        //     //   value: controller.isStatic,
        //     //   onChanged: (value) {
        //     //     controller.updateStaticData(value);
        //     //   },
        //     //   activeColor: AppColor.ligthPurpleColor,
        //     //   activeTrackColor: AppColor.mainColor,
        //     // ),
        //     // Spacer(),
        //   ],
        // ),
        SizedBox(
          height: Responsive.isDesktop(context)
              ? 25
              : Responsive.isTablet(context)
                  ? 20
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

  ///change password
  changePasswordDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<HomeController>(builder: (controller) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 80, vertical: 50),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: "Change Password",
                          fontSize: Responsive.isDesktop(context) ? 23 : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.mainColor,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.clear,
                            color: AppColor.mainColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CommonText(
                      text: "Current Password",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter current password";
                          } else {
                            if (value !=
                                PreferenceManager.getAdminPassword()
                                    .toString()) {
                              return "current password doesn't match with old password";
                            }
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.adminPassController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter current password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      text: "New Password",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          RegExp regex = RegExp(
                              r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                          if (!regex.hasMatch(value!)) {
                            return "Enter valid password";
                          } else {
                            if (value ==
                                PreferenceManager.getAdminPassword()
                                    .toString()) {
                              return "please enter different password";
                            }
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.adminNPassController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter new password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      text: "Confirm New Password",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter confirm password";
                          } else {
                            if (value !=
                                controller.adminNPassController.text
                                    .trim()
                                    .toString()) {
                              return "confirm password doesn't match with password";
                            }
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.adminNewCPassController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter confirm new password',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: 56,
                        width: 250,
                        child: CommonButton(
                          buttonColor: AppColor.mainColor,
                          radius: 10,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              controller.changePassword();
                            }
                          },
                          child: controller.isLoad
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor.whiteColor),
                                )
                              : CommonText(
                                  text: 'Update',
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 20 : 17,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }
}
