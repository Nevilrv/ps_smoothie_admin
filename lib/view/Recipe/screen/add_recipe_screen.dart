import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/view/Recipe/controller/add_recipe_controller.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';

class AddRecipeScreen extends StatelessWidget {
  final HomeController? homeController;
  AddRecipeScreen({Key? key, this.homeController}) : super(key: key);

  AddRecipeController addRecipeController = Get.put(AddRecipeController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30, right: 105 * size, left: 105 * size),
        child: GetBuilder<AddRecipeController>(
          builder: (controller) {
            return SingleChildScrollView(
              controller: controller.scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10 * size),
                        onTap: () {
                          homeController?.updateAddRecipe(false);
                        },
                        child: Container(
                          height: Responsive.isDesktop(context) ? 50 : 40,
                          width: Responsive.isDesktop(context) ? 50 : 40,
                          decoration: BoxDecoration(
                            color: AppColor.ligthPurpleColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImage.homeImage,
                                height: Responsive.isDesktop(context) ? 30 : 20,
                                width: Responsive.isDesktop(context) ? 30 : 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      CommonText(
                        text: 'Upload Recipe',
                        fontSize: Responsive.isDesktop(context)
                            ? 25
                            : Responsive.isTablet(context)
                                ? 20
                                : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 70
                        : Responsive.isTablet(context)
                            ? 50
                            : 30,
                  ),
                  // DottedBorder(
                  //   borderType: BorderType.RRect,
                  //   radius: Radius.circular(12),
                  //   padding: EdgeInsets.all(20),
                  //   dashPattern: [8, 4],
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.all(Radius.circular(12)),
                  //     child: InkWell(
                  //       onTap: () {
                  //         controller.bannerPickImage();
                  //       },
                  //       child: Container(
                  //         height: 200,
                  //         width: 420,
                  //         child: controller.bannerImage != null
                  //             ? Image.memory(
                  //                 controller.bannerImage!,
                  //                 fit: BoxFit.cover,
                  //               )
                  //             : Column(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   Image.asset(
                  //                     AppImage.gallaryImage,
                  //                     height: Responsive.isDesktop(context)
                  //                         ? 50
                  //                         : 30,
                  //                     width: Responsive.isDesktop(context)
                  //                         ? 50
                  //                         : 30,
                  //                   ),
                  //                   CommonText(
                  //                     text: 'Upload Photo',
                  //                     fontSize: Responsive.isDesktop(context)
                  //                         ? 15
                  //                         : Responsive.isTablet(context)
                  //                             ? 12
                  //                             : 10,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ],
                  //               ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    height: Responsive.isDesktop(context)
                        ? 50
                        : Responsive.isTablet(context)
                            ? 40
                            : 40,
                    width: 526,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.textFieldColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: controller.fileName ?? 'Please Select Image',
                          color: AppColor.textColor,
                        ),
                        GestureDetector(
                            onTap: () {
                              controller.bannerPickImage();
                            },
                            child: CommonText(
                                text: 'Choose Image',
                                color: AppColor.mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 15
                        : Responsive.isTablet(context)
                            ? 12
                            : 5,
                  ),

                  CommonText(
                      text: 'Please keep the image resolution size 200 X 300',
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),

                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 20
                        : Responsive.isTablet(context)
                            ? 15
                            : 10,
                  ),

                  SizedBox(
                    width: 526,
                    child: CommonTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Food name';
                        }
                      },
                      cursorColor: AppColor.mainColor,
                      controller: controller.foodNameController,
                      enabledBorderColor: AppColor.transparentColor,
                      focusedBorderColor: AppColor.transparentColor,
                      filledColor: AppColor.textFieldColor,
                      inputTextColor: AppColor.textColor,
                      textFieldSize: 18,
                      borderRadius: 10,
                      inputTextSize: 14,
                      hintText: 'Food Name',
                      hintTextColor: AppColor.textColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 20
                        : Responsive.isTablet(context)
                            ? 15
                            : 10,
                  ),

                  // SizedBox(
                  //   height: controller.pageViewSize[controller.selectedPage],
                  //   child: PageView.builder(
                  //     controller: controller.pageController,
                  //     onPageChanged: (value) {
                  //       controller.updateSelectedPage(value);
                  //     },
                  //     itemCount: controller.sizeCounts.length,
                  //     itemBuilder:
                  //         (BuildContext context, int sizeCountIndex) {
                  //       return Column(
                  //         children: [
                  //           ...List.generate(
                  //             controller.sizeCounts[sizeCountIndex],
                  //             (particularSizeIndex) {
                  //               return Row(
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.center,
                  //                 children: [
                  //                   Container(
                  //                     width: 456,
                  //                     child: Row(
                  //                       children: [
                  //                         Expanded(
                  //                           child: CommonTextField(
                  //                             validator: (value) {
                  //                               if (value!.isEmpty) {
                  //                                 return 'Ingredients name';
                  //                               }
                  //                             },
                  //                             cursorColor: AppColor.mainColor,
                  //                             controller:
                  //                                 controller.ingredientsName[
                  //                                         sizeCountIndex]
                  //                                     [particularSizeIndex],
                  //                             enabledBorderColor:
                  //                                 AppColor.transparentColor,
                  //                             focusedBorderColor:
                  //                                 AppColor.transparentColor,
                  //                             filledColor:
                  //                                 AppColor.textFieldColor,
                  //                             inputTextColor:
                  //                                 AppColor.textColor,
                  //                             textFieldSize: 15,
                  //                             borderRadius: 10,
                  //                             inputTextSize: 15,
                  //                             hintText: 'Ingredients Name',
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 10,
                  //                         ),
                  //                         Expanded(
                  //                           child: CommonTextField(
                  //                             validator: (value) {
                  //                               if (value!.isEmpty) {
                  //                                 return 'Ingredients Detail';
                  //                               }
                  //                             },
                  //                             cursorColor: AppColor.mainColor,
                  //                             controller:
                  //                                 controller.ingredientsValue[
                  //                                         sizeCountIndex]
                  //                                     [particularSizeIndex],
                  //                             enabledBorderColor:
                  //                                 AppColor.transparentColor,
                  //                             focusedBorderColor:
                  //                                 AppColor.transparentColor,
                  //                             filledColor:
                  //                                 AppColor.textFieldColor,
                  //                             inputTextColor:
                  //                                 AppColor.textColor,
                  //                             textFieldSize: 15,
                  //                             borderRadius: 10,
                  //                             inputTextSize: 15,
                  //                             hintText: 'Ingredients Detail',
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 20,
                  //                   ),
                  //                   IconButton(
                  //                     splashRadius: 20,
                  //                     onPressed: () {
                  //                       if (particularSizeIndex == 0) {
                  //                         controller
                  //                             .incrementParticularIngredients(
                  //                                 sizeCountIndex, context);
                  //                       } else {
                  //                         controller
                  //                             .removeParticularIngredients(
                  //                                 sizeCountIndex,
                  //                                 particularSizeIndex);
                  //                       }
                  //                     },
                  //                     icon: Icon(
                  //                       particularSizeIndex == 0
                  //                           ? Icons.add
                  //                           : Icons.remove,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),

                  ListView.builder(
                    itemCount: controller.sizeValue.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 526,
                                child: CommonTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Size';
                                    }
                                  },
                                  cursorColor: AppColor.mainColor,
                                  controller: controller.sizeValue[index],
                                  enabledBorderColor: AppColor.transparentColor,
                                  focusedBorderColor: AppColor.transparentColor,
                                  filledColor: AppColor.textFieldColor,
                                  inputTextColor: AppColor.textColor,
                                  textFieldSize: 18,
                                  borderRadius: 10,
                                  inputTextSize: 14,
                                  hintText: 'Enter Size',
                                  hintTextColor: AppColor.textColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              index == 0
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        controller.removeSizeField(index);
                                      },
                                      child: Icon(Icons.remove))
                            ],
                          ),
                          ListView.builder(
                            itemCount:
                                controller.allIngredientsName[index].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index1) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 456,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Ingredients name';
                                            }
                                          },
                                          cursorColor: AppColor.mainColor,
                                          controller: controller
                                                  .allIngredientsName[index]
                                              [index1],
                                          enabledBorderColor:
                                              AppColor.transparentColor,
                                          focusedBorderColor:
                                              AppColor.transparentColor,
                                          filledColor: AppColor.textFieldColor,
                                          inputTextColor: AppColor.textColor,
                                          textFieldSize: 15,
                                          borderRadius: 10,
                                          inputTextSize: 15,
                                          hintText: 'Ingredients Name',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: CommonTextField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Ingredients Detail';
                                            }
                                          },
                                          cursorColor: AppColor.mainColor,
                                          controller: controller
                                                  .allIngredientsValue[index]
                                              [index1],
                                          enabledBorderColor:
                                              AppColor.transparentColor,
                                          focusedBorderColor:
                                              AppColor.transparentColor,
                                          filledColor: AppColor.textFieldColor,
                                          inputTextColor: AppColor.textColor,
                                          textFieldSize: 15,
                                          borderRadius: 10,
                                          inputTextSize: 15,
                                          hintText: 'Ingredients Detail',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    if (index1 == 0) {
                                      controller.addNewNameField(index);
                                    } else {
                                      controller.removeNewNameField(
                                          index, index1);
                                    }
                                  },
                                  icon: Icon(
                                    index1 == 0 ? Icons.add : Icons.remove,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Responsive.isDesktop(context)
                                ? 20
                                : Responsive.isTablet(context)
                                    ? 15
                                    : 10,
                          ),
                        ],
                      );
                    },
                  ),

                  ElevatedButton(
                    onPressed: () {
                      controller.addNewSizeField();
                    },
                    child: CommonText(
                      text: 'Add',
                      color: AppColor.whiteColor,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColor.mainColor),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8))),
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 20
                        : Responsive.isTablet(context)
                            ? 15
                            : 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: controller.elergic,
                        activeColor: AppColor.mainColor,
                        onChanged: (value) {
                          controller.updateElergic();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CommonText(
                        text: 'Allergic',
                        fontSize: Responsive.isDesktop(context)
                            ? 12
                            : Responsive.isTablet(context)
                                ? 12
                                : 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 30
                        : Responsive.isTablet(context)
                            ? 20
                            : 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 56,
                      width: 526,
                      child: CommonButton(
                        radius: 10,
                        buttonColor: AppColor.mainColor,
                        onPressed: () {
                          controller.addSmoothieToFirebase(context: context);
                          /// ========================================
                          // controller.uploadDataToFirebase(context: context);
                        },
                        child: CommonText(
                          text: 'Upload',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context)
                        ? 20
                        : Responsive.isTablet(context)
                            ? 15
                            : 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
// if (index == 0)
//   SizedBox(
//     height: 30,
//     width: 100,
//     child: CommonButton(
//       buttonColor: AppColor.mainColor,
//       onPressed: () {
//         controller.onChangedIngredientsData(
//             value: controller.selectShakeSize);
//       },
//       child: CommonText(
//         text: 'Add',
//         fontWeight: FontWeight.w700,
//         fontSize: 12,
//         color: AppColor.whiteColor,
//       ),
//     ),
//   ),
