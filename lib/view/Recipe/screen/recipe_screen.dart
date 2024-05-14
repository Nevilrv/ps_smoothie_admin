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
import 'package:ps_smoothie_admin/const/text_field.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.isLoading == true) {
          return Center(
              child: CircularProgressIndicator(color: AppColor.mainColor));
        } else {
          return Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: Responsive.isDesktop(context) ? 700 : 250,
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
                    Spacer(),
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
                        controller.filterSmoothie(value);
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
                              text: "Normal",
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w900,
                            ),
                            value: 1,
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            child: CommonText(
                              text: "Allergic",
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
                    InkWell(
                      borderRadius: BorderRadius.circular(10 * size),
                      onTap: () {
                        controller.titleController.clear();
                        controller.descriptionController.clear();
                        addNotificationDialog(context);
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
                              size: Responsive.isDesktop(context) ? 30 : 20,
                            ),
                            CommonText(
                              text: "Add Notification",
                              fontSize: Responsive.isDesktop(context) ? 18 : 17,
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
                      ? 25
                      : Responsive.isTablet(context)
                          ? 20
                          : 15,
                ),
                controller.searchController.text.isNotEmpty &&
                        controller.smoothieSearchedData.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 200),
                        child: Center(
                          child: Text(
                            "No smoothie found !!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColor.mainColor,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: MasonryGridView.count(
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
                                      imageUrl:
                                          controller.smoothieSearchedData[index]
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
                                          baseColor:
                                              Colors.grey.withOpacity(0.4),
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
                                          vertical: 14 * size,
                                          horizontal: 10 * size),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CommonButton(
                                                buttonColor: controller
                                                            .smoothieSearchedData[
                                                        index]['data']["isActive"]
                                                    ? AppColor.mainColor
                                                    : AppColor.ligthPurpleColor,
                                                radius: 10,
                                                onPressed: () async {
                                                  if (controller
                                                          .smoothieSearchedData[
                                                      index]['data']["isActive"]) {
                                                    controller.smoothieData[
                                                            index]['data']
                                                        ['isActive'] = false;
                                                    controller.smoothieSearchedData[
                                                            index]['data']
                                                        ['isActive'] = false;
                                                    controller.update();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'smoothieCollection')
                                                        .doc(controller
                                                                .smoothieSearchedData[
                                                            index]['id'])
                                                        .update({
                                                      'isActive': false,
                                                      'time': DateTime.now()
                                                    });
                                                  } else {
                                                    controller.smoothieData[
                                                            index]['data']
                                                        ['isActive'] = true;
                                                    controller.smoothieSearchedData[
                                                            index]['data']
                                                        ['isActive'] = true;
                                                    controller.update();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'smoothieCollection')
                                                        .doc(controller
                                                                .smoothieSearchedData[
                                                            index]['id'])
                                                        .update({
                                                      'isActive': true,
                                                      'time': DateTime.now()
                                                    });
                                                  }
                                                },
                                                child: CommonText(
                                                  text:
                                                      controller.smoothieSearchedData[
                                                                  index]['data']
                                                              ["isActive"]
                                                          ? 'Active'
                                                          : 'InActive ',
                                                  color:
                                                      controller.smoothieSearchedData[
                                                                  index]['data']
                                                              ["isActive"]
                                                          ? AppColor.whiteColor
                                                          : AppColor.mainColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? 15
                                                          : 13,
                                                ),
                                              ),
                                              PopupMenuButton<int>(
                                                splashRadius: 20,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                position:
                                                    PopupMenuPosition.under,
                                                icon: SvgPicture.asset(
                                                  AppImage.menuImage,
                                                  height: size * 24,
                                                  width: size * 24,
                                                ),
                                                onSelected: (value) async {
                                                  if (value == 0) {
                                                    Get.to(() =>
                                                        SmoothieEditScreen(
                                                          smoothieData: controller
                                                                  .smoothieSearchedData[
                                                              index]['data'],
                                                          documentId: controller
                                                                  .smoothieSearchedData[
                                                              index]['id'],
                                                        ));
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Center(
                                                              child: CommonText(
                                                                text:
                                                                    'Do you really want to delete the shake?',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            actions: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          40,
                                                                      width: 80,
                                                                      child:
                                                                          CommonButton(
                                                                        buttonColor:
                                                                            AppColor.mainColor,
                                                                        radius:
                                                                            10,
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('smoothieCollection')
                                                                              .doc(controller.smoothieSearchedData[index]['id'])
                                                                              .delete();
                                                                          Get.back();
                                                                        },
                                                                        child:
                                                                            CommonText(
                                                                          text:
                                                                              'Yes',
                                                                          color:
                                                                              AppColor.whiteColor,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                AppColor.mainColor,
                                                                          ),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            CommonText(
                                                                          text:
                                                                              'No',
                                                                          color:
                                                                              AppColor.mainColor,
                                                                          fontWeight:
                                                                              FontWeight.w600,
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
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    PopupMenuItem(
                                                      child: CommonText(
                                                        text: "Edit",
                                                        color:
                                                            AppColor.blackColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                      value: 0,
                                                    ),
                                                    const PopupMenuDivider(),
                                                    PopupMenuItem(
                                                      child: CommonText(
                                                        text: "Delete",
                                                        color:
                                                            AppColor.blackColor,
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
                                          CommonText(
                                            text:
                                                '${controller.smoothieSearchedData[index]['data']['name']}',
                                            fontSize: Responsive.isDesktop(
                                                    context)
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
                      ),
              ],
            ),
          );
        }
      },
    );
  }

  addNotificationDialog(BuildContext context) {
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
                          text: "Send Notification",
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
                      text: "title",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.titleController,
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
                      text: "Description",
                      fontSize: Responsive.isDesktop(context) ? 20 : 17,
                      fontWeight: FontWeight.w400,
                      color: AppColor.blackColor,
                    ),
                    Container(
                      width: Responsive.isDesktop(context) ? 500 : 350,
                      child: CommonTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                        },
                        cursorColor: AppColor.mainColor,
                        controller: controller.descriptionController,
                        enabledBorderColor: AppColor.transparentColor,
                        focusedBorderColor: AppColor.transparentColor,
                        filledColor: AppColor.textFieldColor,
                        inputTextColor: AppColor.textColor,
                        textFieldSize: 15,
                        borderRadius: 10,
                        maxLines: 5,
                        inputTextSize: 15,
                        hintText: 'Enter description',
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
                              controller.sendNotification();
                            }
                          },
                          child: controller.isLoad
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor.whiteColor),
                                )
                              : CommonText(
                                  text: 'Send',
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
