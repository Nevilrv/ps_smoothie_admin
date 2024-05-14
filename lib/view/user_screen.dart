import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/collection.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/date_format.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class UserScreen extends StatelessWidget {
  final HomeController homeController;
  UserScreen({Key? key, required this.homeController}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Responsive.isMobile(context)
              ? SizedBox()
              : VerticalDivider(
                  color: AppColor.dividerColor,
                  thickness: 1,
                ),
          GetBuilder<HomeController>(builder: (controller) {
            return StreamBuilder(
              stream: controller.selectedFilter == 0
                  ? FirebaseFirestore.instance.collection('user').snapshots()
                  : controller.selectedFilter == 1
                      ? FirebaseFirestore.instance
                          .collection('user')
                          .where('isUserActive', isEqualTo: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('user')
                          .where('isUserActive', isEqualTo: false)
                          .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data?.docs;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton<int>(
                            splashRadius: 20,
                            offset: Offset(0, 15),
                            constraints: BoxConstraints(minWidth: 200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            position: PopupMenuPosition.under,
                            child: Container(
                              height: Responsive.isDesktop(context) ? 50 : 45,
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(
                                color: AppColor.ligthPurpleColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Image.asset(
                                  AppImage.filter,
                                  color: AppColor.mainColor,
                                  width: 30,
                                  height: 40,
                                ),
                              ),
                            ),
                            onSelected: (value) {
                              log('value ---------->>>>>>>> ${value}');
                              controller.setSelectedFilter(value);
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: CommonText(
                                    text: "All",
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  value: 0,
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  child: CommonText(
                                    text: "Active",
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  value: 1,
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  child: CommonText(
                                    text: "InActive",
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  value: 2,
                                ),
                              ];
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              homeController.nameController.clear();
                              homeController.emailController.clear();
                              homeController.passwordController.clear();
                              homeController.cPasswordController.clear();
                              addEditUserDialog(context, isAdd: true);
                            },
                            child: Container(
                              height: Responsive.isDesktop(context) ? 50 : 45,
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(
                                color: AppColor.ligthPurpleColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColor.mainColor,
                                    size:
                                        Responsive.isDesktop(context) ? 30 : 20,
                                  ),
                                  CommonText(
                                    text: "Add User",
                                    fontSize:
                                        Responsive.isDesktop(context) ? 18 : 17,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.mainColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context)
                            ? 20
                            : Responsive.isTablet(context)
                                ? 20
                                : 15,
                      ),
                      data!.isEmpty
                          ? Center(
                              child: CommonText(
                                text: "No User Found",
                                fontSize:
                                    Responsive.isDesktop(context) ? 21 : 18,
                                fontWeight: FontWeight.w400,
                                color: AppColor.mainColor,
                              ),
                            )
                          : Expanded(
                              child: MasonryGridView.count(
                                crossAxisCount:
                                    Responsive.isMobile(context) ? 1 : 2,
                                // mainAxisSpacing: 26 * size,
                                crossAxisSpacing: 26 * size,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  if (data[index]["isMember"] == true) {
                                    DateTime date =
                                        DateTime.parse(data[index]["endDate"]);

                                    if (date.isBefore(DateTime.now())) {
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc('${data[index].id}')
                                          .update({
                                        'isMember': false,
                                        'endDate': "",
                                      });
                                    }
                                  }

                                  return Container(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100000),
                                              child: CachedNetworkImage(
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    'https://wallpapercave.com/dwp1x/wp11755847.jpg',
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Icon(Icons.person),
                                                ),
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                        downloadProgress) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.grey
                                                        .withOpacity(0.4),
                                                    highlightColor: Colors.grey
                                                        .withOpacity(0.2),
                                                    enabled: true,
                                                    child: Container(
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CommonText(
                                                  text:
                                                      '${data[index]['userName']}',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    CommonText(
                                                      text:
                                                          '${data[index]['userEmail']}',
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.grey100Color,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    CommonText(
                                                      text:
                                                          '${data[index]['userPhoneNumber']}',
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.grey100Color,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    CommonText(
                                                      text: 'PW : ',
                                                      fontSize: 14,
                                                    ),
                                                    CommonText(
                                                      text:
                                                          '${data[index]['userPassword']}',
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.grey100Color,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    CommonText(
                                                      text: 'Membership Status',
                                                      fontSize: 13,
                                                    ),
                                                    Switch(
                                                      value: data[index]
                                                          ['isMember'],
                                                      activeColor: AppColor
                                                          .ligthPurpleColor,
                                                      activeTrackColor:
                                                          AppColor.mainColor,
                                                      onChanged: (value) async {
                                                        homeController
                                                            .showProgressDialog();

                                                        if (value == true) {
                                                          DateTime? pickedDate =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 1)),
                                                            firstDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 1)),
                                                            lastDate:
                                                                DateTime(3000),
                                                          );
                                                          if (pickedDate !=
                                                              null) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'user')
                                                                .doc(data[index]
                                                                    .id)
                                                                .update({
                                                              'isMember': value,
                                                              'endDate':
                                                                  "$pickedDate"
                                                            });
                                                          }

                                                          homeController
                                                              .hideProgressDialog();
                                                        } else {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(data[index]
                                                                  .id)
                                                              .update({
                                                            'isMember': value,
                                                            'endDate': ""
                                                          }).whenComplete(() {
                                                            homeController
                                                                .hideProgressDialog();
                                                          });
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                                if (data[index]['isMember'] ==
                                                    true)
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                        text: 'End Date : ',
                                                        fontSize: 13,
                                                      ),
                                                      CommonText(
                                                        text:
                                                            '${formattedDate(data[index]['endDate'])}',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColor.blackColor,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CommonButton(
                                                  buttonColor: data[index]
                                                          ["isUserActive"]
                                                      ? AppColor.mainColor
                                                      : AppColor
                                                          .ligthPurpleColor,
                                                  radius: 10,
                                                  onPressed: () async {
                                                    if (data[index]
                                                        ["isUserActive"]) {
                                                      await userCollection
                                                          .doc(data[index].id)
                                                          .update({
                                                        'isUserActive': false,
                                                      });
                                                    } else {
                                                      await userCollection
                                                          .doc(data[index].id)
                                                          .update({
                                                        'isUserActive': true,
                                                      });
                                                    }
                                                  },
                                                  child: CommonText(
                                                    text: data[index]
                                                            ["isUserActive"]
                                                        ? 'Active'
                                                        : 'InActive ',
                                                    color: data[index]
                                                            ["isUserActive"]
                                                        ? AppColor.whiteColor
                                                        : AppColor.mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 17
                                                            : 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                PopupMenuButton<int>(
                                                  splashRadius: 20,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  position:
                                                      PopupMenuPosition.under,
                                                  icon: SvgPicture.asset(
                                                    AppImage.menuImage,
                                                    color: AppColor.mainColor,
                                                    height: size * 24,
                                                    width: size * 24,
                                                  ),
                                                  onSelected: (value) async {
                                                    if (value == 0) {
                                                      homeController
                                                              .nameController
                                                              .text =
                                                          data[index]
                                                              ['userName'];
                                                      homeController
                                                              .emailController
                                                              .text =
                                                          data[index]
                                                              ['userEmail'];
                                                      homeController
                                                          .passwordController
                                                          .text = data[
                                                              index]
                                                          ['userPassword'];

                                                      addEditUserDialog(context,
                                                          id: data[index].id);
                                                    } else {
                                                      deleteUserDialog(context,
                                                          id: data[index].id,
                                                          email: data[index]
                                                              ['userEmail'],
                                                          password: data[index]
                                                              ['userPassword']);
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    return [
                                                      PopupMenuItem(
                                                        child: CommonText(
                                                          text: "Edit",
                                                          color: AppColor
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                        value: 0,
                                                      ),
                                                      const PopupMenuDivider(),
                                                      PopupMenuItem(
                                                        child: CommonText(
                                                          text: "Delete",
                                                          color: AppColor
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                        value: 1,
                                                      ),
                                                    ];
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Divider(
                                          color: AppColor.dividerColor,
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.mainColor),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }

  addEditUserDialog(BuildContext context, {bool isAdd = false, String? id}) {
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
                          text: isAdd ? "Add User" : "Edit User",
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
                      text: "User Name",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter user name';
                          }
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.nameController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter title',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      text: "User Email",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          RegExp regex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!regex.hasMatch(value!)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.emailController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter user email',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      text: "Password",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          RegExp regex = RegExp(
                              r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                          if (!regex.hasMatch(value!)) {
                            return "Enter valid password";
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.passwordController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      text: "Confirm Password",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter confirm password";
                          } else {
                            if (value !=
                                controller.passwordController.text
                                    .trim()
                                    .toString()) {
                              return "confirm password doesn't match with password";
                            }
                          }
                          return null;
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.cPasswordController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        inputTextSize: 15,
                        hintText: 'Enter confirm password ',
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
                              if (isAdd) {
                                controller.createUser();
                              } else {
                                controller.editUser(id: id);
                              }
                            }
                          },
                          child: controller.isUserLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor.whiteColor),
                                )
                              : CommonText(
                                  text: isAdd ? 'Add User' : 'Edit User',
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

  deleteUserDialog(BuildContext context,
      {String? id, String? email, String? password}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: CommonText(
                text: 'Do you really want to delete this user?',
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              GetBuilder<HomeController>(builder: (controller) {
                return controller.isDeleteLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: AppColor.mainColor),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 40,
                              width: 80,
                              child: CommonButton(
                                buttonColor: AppColor.mainColor,
                                radius: 10,
                                onPressed: () async {
                                  controller.deleteUser(
                                      email: email, password: password);
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
                      );
              }),
            ],
          );
        });
  }
}
