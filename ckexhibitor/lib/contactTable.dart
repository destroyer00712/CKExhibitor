import 'dart:convert';

import 'package:ckexhibitor/visitorTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactTable extends StatefulWidget {
  const ContactTable({super.key});

  @override
  State<ContactTable> createState() => _ContactTableState();
}

class _ContactTableState extends State<ContactTable> {
  String dbName = "";
  String number = "";
  var _visJSON = [];
  @override
  void initState() {
    populateData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('visitorData')! as String;
      print(number);
    });
  }

  void populateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('visitorData')! as String;
      dbName = prefs.getString('dbName')! as String;
      print(dbName);
      print(number);
    });
    final url =
        "http://naman.xstream.biz/request.php?action=GET_SELECTED&number=$number";
    print(url);
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        _visJSON = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  void sendData(
      String table,
      String name,
      String email,
      String number,
      String state,
      String district,
      String company,
      String address,
      String type) async {
    final url =
        "http://naman.xstream.biz/request.php?table=$table&action=ADD_VIS&name=$name&email=$email&number=$number&state=$state&district=$district&company=$company&address=$address&type=$type";
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
      body: ListView.builder(
        itemCount: _visJSON.length,
        itemBuilder: (context, i) {
          final vis = _visJSON[i];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                          "Name: ${vis["name"]}\n Number : ${vis["number"]}, email : ${vis["email"]}"),
                      ElevatedButton(
                          onPressed: () {
                            sendData(
                                dbName,
                                vis["name"],
                                vis["email"],
                                vis["number"],
                                vis["state"],
                                vis["district"],
                                vis["company"],
                                vis["address"],
                                vis["type"]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitorTable()));
                          },
                          child: Text("Continue"))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
