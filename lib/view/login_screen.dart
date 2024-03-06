import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/common_snackbar.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/controller/auth_controller.dart';
import 'package:ps_smoothie_admin/get_storage/get_storage_service.dart';
import 'package:ps_smoothie_admin/view/home_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(250, 182, 13, 0.5),
              Color.fromRGBO(247, 135, 18, 0.5),
              Color.fromRGBO(183, 8, 87, 0.5),
            ],
          ),
        ),
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(50),
                height: 570,
                width: 714,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                constraints: BoxConstraints(minWidth: 363 * size),
                padding: EdgeInsets.symmetric(horizontal: 68),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImage.logoImage,
                        height: 147,
                        width: 147,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CommonText(
                        text: 'Login',
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: AppColor.mainColor,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.emailController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 23,
                        borderRadius: 10,
                        inputTextSize: 18,
                        hintText: 'Enter your email',
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.passwordController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 23,
                        borderRadius: 10,
                        inputTextSize: 18,
                        hintText: 'Enter your password',
                      ),
                      SizedBox(
                        height: 52,
                      ),
                      SizedBox(
                        height: 56,
                        width: 388,
                        child: CommonButton(
                          radius: 10,
                          buttonColor: AppColor.mainColor,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // bool status = await controller.logInMethod(
                              //     email: controller.emailController.text.trim(),
                              //     password:
                              //         controller.passwordController.text.trim(),
                              //     context: context);
                              // if (status == true) {
                              //   Get.offAll(() => HomeScreen());
                              //   PreferenceManager.setLogin(true);
                              // }

                              if (controller.emailController.text !=
                                  'admin@gmail.com') {
                                CommonSnackBar.showSnackBar(
                                    context: context,
                                    title: "The email address is not valid.");
                              } else if (controller.passwordController.text !=
                                  'Admin@123') {
                                CommonSnackBar.showSnackBar(
                                    context: context,
                                    title:
                                        "The password is invalid for the given email.");
                              } else if (controller.emailController.text ==
                                      'admin@gmail.com' &&
                                  controller.passwordController.text ==
                                      'Admin@123') {
                                Get.offAll(() => HomeScreen());
                                PreferenceManager.setLogin(true);
                              } else{
                                CommonSnackBar.showSnackBar(
                                    context: context,
                                    title:
                                    "Something Went Wrong");

                              }
                            }
                          },
                          child: CommonText(
                            text: 'Login',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
