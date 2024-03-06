import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/button.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:ps_smoothie_admin/view/Recipe/controller/edit_recipe_controller.dart';
import 'package:ps_smoothie_admin/view/Recipe/screen/display_recipe_details.dart';
import 'package:ps_smoothie_admin/view/Recipe/screen/edit_smoothie_screen.dart';
import 'package:shimmer/shimmer.dart';

class RecipeScreen extends StatefulWidget {
  final HomeController homeController;
  const RecipeScreen({
    super.key,
    required this.homeController,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return GetBuilder<HomeController>(
      builder: (controller) {
        log("controller.smoothieSearchedData.lengt--------------> ${controller.smoothieSearchedData.length}");
        if (controller.isLoading == true) {
          return Center(
              child: CircularProgressIndicator(color: AppColor.mainColor));
        } else {
          return Expanded(
            child: controller.searchController.text.isNotEmpty &&
                    controller.smoothieSearchedData.isEmpty
                ? Center(
                    child: Text(
                      "No smoothie found !!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColor.mainColor,
                      ),
                    ),
                  )
                : MasonryGridView.count(
                    crossAxisCount: Responsive.isDesktop(context)
                        ? 4
                        : Responsive.isTablet(context)
                            ? 3
                            : 2,
                    mainAxisSpacing: 26 * size,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    crossAxisSpacing: 26 * size,
                    itemCount: controller.smoothieSearchedData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => SmoothieDetailsScreen(
                                smoothieData: controller
                                    .smoothieSearchedData[index]['data'],
                              ));
                        },
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: Responsive.isDesktop(context)
                              ? 264
                              : Responsive.isTablet(context)
                                  ? 200
                                  : 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.ligthPurpleColor,
                          ),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                height: Responsive.isDesktop(context)
                                    ? 264
                                    : Responsive.isTablet(context)
                                        ? 200
                                        : 150,
                                imageUrl: controller.smoothieSearchedData[index]
                                    ['data']['image'],
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  print('-------error$error');
                                  return Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Icon(Icons.error_outline),
                                  );
                                },
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.withOpacity(0.4),
                                    highlightColor:
                                        Colors.grey.withOpacity(0.2),
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14 * size, horizontal: 26 * size),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton<int>(
                                        splashRadius: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        position: PopupMenuPosition.under,
                                        icon: SvgPicture.asset(
                                          AppImage.menuImage,
                                          height: size * 24,
                                          width: size * 24,
                                        ),
                                        onSelected: (value) async {
                                          if (value == 0) {
                                            await Get.to(() =>
                                                SmoothieEditScreen(
                                                  smoothieData: controller
                                                          .smoothieData[index]
                                                      ['data'],
                                                  documentId: controller
                                                          .smoothieData[index]
                                                      ['id'],
                                                ))?.then((value) async {
                                              log('----dddd-----');
                                              await controller.getRecipeData();
                                            });
                                          } else {
                                            log('----------deew');

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Center(
                                                      child: CommonText(
                                                        text:
                                                            'Do you really want to delete the shake?',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: SizedBox(
                                                              height: 40,
                                                              width: 80,
                                                              child:
                                                                  CommonButton(
                                                                buttonColor:
                                                                    AppColor
                                                                        .mainColor,
                                                                radius: 10,
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'smoothieCollection')
                                                                      .doc(controller
                                                                              .smoothieData[index]
                                                                          [
                                                                          'id'])
                                                                      .delete();
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    CommonText(
                                                                  text: 'Yes',
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Container(
                                                                height: 40,
                                                                width: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColor
                                                                        .mainColor,
                                                                  ),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    CommonText(
                                                                  text: 'No',
                                                                  color: AppColor
                                                                      .mainColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                text: "Edit",
                                                color: AppColor.blackColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              value: 0,
                                            ),
                                            const PopupMenuDivider(),
                                            PopupMenuItem(
                                              child: CommonText(
                                                text: "Delete",
                                                color: AppColor.blackColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              value: 1,
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                    CommonText(
                                      text:
                                          '${controller.smoothieSearchedData[index]['data']['name']}',
                                      fontSize: Responsive.isDesktop(context)
                                          ? 25
                                          : Responsive.isTablet(context)
                                              ? 20
                                              : 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}
