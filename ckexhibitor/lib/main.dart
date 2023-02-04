import 'package:ckexhibitor/home_screen.dart';
import 'package:ckexhibitor/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String data = "";

  // This widget is the root of your application.
  @override
  void initState() {
    checkData();
  }

  checkData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('dbName');
  }

  display() {
    if (data != null) {
      return HomeScreen();
    } else {
      return RegisterScreen();
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: display(),
    );
  }
}
