import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  String visitorData = "";
  List<String> visitorInfo = [];
  TextEditingController note = TextEditingController();
  @override
  void initState() {
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('visitorInfo') == null) {
        prefs.setStringList('visitorInfo', []);
      } else {
        visitorInfo = prefs.getStringList('visitorInfo')! as List<String>;
        visitorData = prefs.getString('visitorData')! as String;
        visitorInfo.add(visitorData);
        prefs.setStringList('visitorInfo', visitorInfo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 186, 219, 1),
      body: ListView.builder(
        itemCount: visitorInfo.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onDoubleTap: () {
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
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 300,
                            ),
                            TextField(
                              controller: note,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText: "Enter a note",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(95, 186, 219, 1)),
                                  )),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('Note$index', note.text);
                              },
                              child: Text("Enter"),
                            ),
                            ElevatedButton(
                              child: Text("Close"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Card(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SelectableText(
                        visitorInfo[index],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
