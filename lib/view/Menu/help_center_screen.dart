import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/date_format.dart';

import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:shimmer/shimmer.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: 0 * size, right: 105 * size, left: 105 * size),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            AppImage.logoImage,
            height: 147,
            width: 147,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('helpSupport')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data?.docs;
                return Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: Responsive.isMobile(context) ? 1 : 1,
                    crossAxisSpacing: 26 * size,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100000),
                                  child: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        'https://wallpapercave.com/dwp1x/wp11755847.jpg',
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Icon(Icons.person),
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
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: '${data[index]['userName']}',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: Responsive.isDesktop(context)
                                          ? 1050 * size
                                          : Responsive.isTablet(context)
                                              ? 950 * size
                                              : 900 * size,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            text: '${data[index]['question']}',
                                            fontSize: 12,
                                            color: AppColor.grey100Color,
                                          ),
                                          Spacer(),
                                          CommonText(
                                            text:
                                                '${formattedDate(data[index]['createAt'])}',
                                            // text: '${data[index]['createAt']}',
                                            fontSize: 12,
                                            color: AppColor.grey100Color,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: AppColor.dividerColor,
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    },
                  ),
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
          ),
        ]),
      ),
    );
  }
}
