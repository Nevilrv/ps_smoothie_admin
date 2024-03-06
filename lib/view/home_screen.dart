import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/controller/home_controller.dart';
import 'package:ps_smoothie_admin/view/Recipe/screen/add_recipe_screen.dart';
import 'package:ps_smoothie_admin/view/show_data_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController.getRecipeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 1440;
    double font = size * 0.97;
    print('-------------${size * 1440}');
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
                top: 90 * size, right: 105 * size, left: 105 * size),
            child: controller.addRecipe == true
                ? AddRecipeScreen(homeController: controller)
                : ShowDataScreen(controller: controller),
          ),
        );
      },
    );
  }
}
