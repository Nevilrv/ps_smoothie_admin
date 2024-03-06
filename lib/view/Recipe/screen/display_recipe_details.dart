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

class SmoothieDetailsScreen extends StatefulWidget {
  const SmoothieDetailsScreen({super.key, required this.smoothieData});
  final Map<String, dynamic> smoothieData;

  @override
  State<SmoothieDetailsScreen> createState() => _SmoothieDetailsScreenState();
}

class _SmoothieDetailsScreenState extends State<SmoothieDetailsScreen> {
  ScrollController scrollController = ScrollController();
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return Scaffold(
      body: Padding(
          padding:
              EdgeInsets.only(top: 30, right: 105 * size, left: 105 * size),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10 * size),
                      onTap: () {
                        Get.back();
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
                      width: Responsive.isDesktop(context) ? 40 : 20,
                    ),
                    CommonText(
                      text: 'Recipe Details',
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
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(10),
                  dashPattern: [8, 4],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: Responsive.isDesktop(context)
                          ? 170
                          : Responsive.isTablet(context)
                              ? 150
                              : 140,
                      width: Responsive.isDesktop(context)
                          ? 300
                          : Responsive.isTablet(context)
                              ? 250
                              : 220,
                      child: widget.smoothieData['image'] != null
                          ? Image.network(
                              widget.smoothieData['image'],
                              fit: BoxFit.fitWidth,
                            )
                          : Image.asset(
                              AppImage.gallaryImage,
                              height: Responsive.isDesktop(context) ? 50 : 30,
                              width: Responsive.isDesktop(context) ? 50 : 30,
                            ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Responsive.isDesktop(context)
                      ? 30
                      : Responsive.isTablet(context)
                          ? 20
                          : 15,
                ),

                // SizedBox(
                //   width: Responsive.isDesktop(context)
                //       ? 526
                //       : Responsive.isTablet(context)
                //           ? 500
                //           : 450,
                //   child: CommonTextField(
                //     cursorColor: AppColor.mainColor,
                //     controller: TextEditingController(
                //         text: widget.smoothieData['name']),
                //     enabledBorderColor: AppColor.transparentColor,
                //     focusedBorderColor: AppColor.transparentColor,
                //     filledColor: AppColor.textFieldColor,
                //     inputTextColor: AppColor.textColor,
                //     textFieldSize: 18,
                //     borderRadius: 10,
                //     inputTextSize: 14,
                //     hintText: 'Food Name',
                //     hintTextColor: AppColor.textColor,
                //     fontFamily: 'Poppins',
                //   ),
                // ),
                Container(
                    width: Responsive.isDesktop(context)
                        ? 526
                        : Responsive.isTablet(context)
                            ? 500
                            : 450,
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(right: 5, top: 0, bottom: 5),
                    decoration: BoxDecoration(
                        color: AppColor.textFieldColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CommonText(
                        text: widget.smoothieData['name'],
                        textAlign: TextAlign.left,
                        color: AppColor.blackColor,
                      ),
                    )),

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
                  itemCount: widget.smoothieData['size'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: Responsive.isDesktop(context)
                                ? 526
                                : Responsive.isTablet(context)
                                    ? 500
                                    : 450,
                            decoration: BoxDecoration(
                                color: AppColor.textFieldColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CommonText(
                                text: widget.smoothieData['size'][index]
                                    ['size'],
                                textAlign: TextAlign.left,
                                color: AppColor.blackColor,
                              ),
                            )),
                        SizedBox(
                          height: 12,
                        ),
                        ListView.builder(
                          itemCount:
                              widget.smoothieData['size'][index]['key'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index1) => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: Responsive.isDesktop(context)
                                    ? 456
                                    : Responsive.isTablet(context)
                                        ? 400
                                        : 350,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 45,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          margin: EdgeInsets.only(
                                              right: 5, top: 0, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: AppColor.textFieldColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CommonText(
                                              text: widget.smoothieData['size']
                                                  [index]['key'][index1],
                                              textAlign: TextAlign.left,
                                              color: AppColor.blackColor,
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),

                                    Expanded(
                                      child: Container(
                                          height: 45,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          margin: EdgeInsets.only(
                                              right: 5, top: 0, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: AppColor.textFieldColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CommonText(
                                              text: widget.smoothieData['size']
                                                  [index]['value'][index1],
                                              textAlign: TextAlign.left,
                                              color: AppColor.blackColor,
                                            ),
                                          )),
                                    ),

                                    // Expanded(
                                    //   child: CommonTextField(
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return 'Ingredients name';
                                    //       }
                                    //     },
                                    //     cursorColor: AppColor.mainColor,
                                    //     readOnly: true,
                                    //     controller: TextEditingController(
                                    //         text: widget.smoothieData['size']
                                    //             [index]['key'][index1]),
                                    //     enabledBorderColor:
                                    //         AppColor.transparentColor,
                                    //     focusedBorderColor:
                                    //         AppColor.transparentColor,
                                    //     filledColor: AppColor.textFieldColor,
                                    //     inputTextColor: AppColor.textColor,
                                    //     textFieldSize: 15,
                                    //     borderRadius: 10,
                                    //     inputTextSize: 15,
                                    //     hintText: 'Ingredients Name',
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    // Expanded(
                                    //   child: CommonTextField(
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return 'Ingredients Detail';
                                    //       }
                                    //     },
                                    //     cursorColor: AppColor.mainColor,
                                    //     readOnly: true,
                                    //     controller: TextEditingController(
                                    //         text: widget.smoothieData['size']
                                    //             [index]['value'][index1]),
                                    //     enabledBorderColor:
                                    //         AppColor.transparentColor,
                                    //     focusedBorderColor:
                                    //         AppColor.transparentColor,
                                    //     filledColor: AppColor.textFieldColor,
                                    //     inputTextColor: AppColor.textColor,
                                    //     textFieldSize: 15,
                                    //     borderRadius: 10,
                                    //     inputTextSize: 15,
                                    //     hintText: 'Ingredients Detail',
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
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
                      value: widget.smoothieData['elergic'],
                      activeColor: AppColor.mainColor,
                      onChanged: (value) {
                        // controller.updateElergic();
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
              ],
            ),
          )),
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
