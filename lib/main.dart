import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps_smoothie_admin/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCfsbCYkdM9mW2Szrv4R6hswhURmV2QHp4",
        authDomain: "pssmoothie-16f00.firebaseapp.com",
        projectId: "pssmoothie-16f00",
        storageBucket: "pssmoothie-16f00.appspot.com",
        messagingSenderId: "179708971979",
        appId: "1:179708971979:web:b350fc6292b86cf83fc44e",
        measurementId: "G-SS78VXJ0X8"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ps Smoothie Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      // home: PreferenceManager.getLogin() == true ? HomeScreen() : MainScreen(),
    );
  }
}
