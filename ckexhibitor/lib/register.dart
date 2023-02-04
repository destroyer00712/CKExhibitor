import 'dart:convert';

import 'package:ckexhibitor/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();

  void createTable(String table) async {
    final url =
        "http://naman.xstream.biz/request.php?table=$table&action=CREATE%20TABLE";

    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 186, 219, 1),
      body: Container(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Image.asset(
                "images/CKLogo.png",
                width: 250,
                height: 250,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    hintText: "company name(only 1 word no spaces)"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    createTable(name.text);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('dbName', name.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text("Enter"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(42, 75, 157, 1)))
            ],
          ),
        ),
      )),
    );
  }
}
