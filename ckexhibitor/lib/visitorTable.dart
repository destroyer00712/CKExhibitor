import 'dart:convert';

import 'package:ckexhibitor/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitorTable extends StatefulWidget {
  const VisitorTable({super.key});

  @override
  State<VisitorTable> createState() => _VisitorTableState();
}

class _VisitorTableState extends State<VisitorTable> {
  String dbName = "";
  TextEditingController note = TextEditingController();
  var _visJSON = [];
  void populateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dbName = prefs.getString('dbName')! as String;
      print(dbName);
    });
    final url =
        "http://naman.xstream.biz/request.php?action=GET_ALL&table=$dbName";
    print(url);
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body);
      setState(() {
        _visJSON = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  void MakeDirectCall(String number) async {
    FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  void initState() {
    // TODO: implement initState
    populateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 186, 219, 1),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                                "Name: ${vis["name"]}\n Number : ${vis["number"]}, email : ${vis["email"]}\n Company : ${vis["company"]}"),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    MakeDirectCall(vis["number"]);
                                  },
                                  child: Text("Call"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                  ),
                                                  SelectableText(
                                                      " Name: ${vis["name"]}\n Number : ${vis["number"]}\n email : ${vis["email"]}\n Company : ${vis["company"]}\n State: ${vis["state"]}\n District: ${vis["district"]}\n Address: ${vis["address"]}\n Type: ${vis["type"]}"),
                                                  SizedBox(
                                                    height: 300,
                                                  ),
                                                  ElevatedButton(
                                                    child: Text("Close"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Details"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text("Home"),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
