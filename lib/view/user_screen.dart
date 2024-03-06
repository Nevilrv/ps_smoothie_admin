import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ps_smoothie_admin/const/app_image.dart';
import 'package:ps_smoothie_admin/const/color.dart';
import 'package:ps_smoothie_admin/const/date_format.dart';
import 'package:ps_smoothie_admin/const/responsive.dart';
import 'package:ps_smoothie_admin/const/text.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class UserScreen extends StatelessWidget {
  final HomeController homeController;
  const UserScreen({Key? key, required this.homeController}) : super(key: key);

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
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data?.docs;

                return MasonryGridView.count(
                  crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                  // mainAxisSpacing: 26 * size,
                  crossAxisSpacing: 26 * size,
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    if (data[index]["isMember"] == true) {
                      DateTime date = DateTime.parse(data[index]["endDate"]);

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
                                  errorWidget: (context, url, error) => Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(
                                    text: '${data[index]['userName']}',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      CommonText(
                                        text: '${data[index]['userEmail']}',
                                        fontSize: 12,
                                        color: AppColor.grey100Color,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CommonText(
                                        text:
                                            '${data[index]['userPhoneNumber']}',
                                        fontSize: 12,
                                        color: AppColor.grey100Color,
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
                                        text: '${data[index]['userPassword']}',
                                        fontSize: 12,
                                        color: AppColor.grey100Color,
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
                                        value: data[index]['isMember'],
                                        activeColor: AppColor.ligthPurpleColor,
                                        activeTrackColor: AppColor.mainColor,
                                        onChanged: (value) async {
                                          homeController.showProgressDialog();

                                          if (value == true) {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now()
                                                  .add(Duration(days: 1)),
                                              firstDate: DateTime.now()
                                                  .add(Duration(days: 1)),
                                              lastDate: DateTime(3000),
                                            );
                                            if (pickedDate != null) {
                                              await FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(data[index].id)
                                                  .update({
                                                'isMember': value,
                                                'endDate': "$pickedDate"
                                              });
                                            }

                                            homeController.hideProgressDialog();
                                          } else {
                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(data[index].id)
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
                                  if (data[index]['isMember'] == true)
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
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.blackColor,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                AppImage.menuImage,
                                color: AppColor.mainColor,
                                height: 15,
                                width: 15,
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
        ],
      ),
    );
  }
}
