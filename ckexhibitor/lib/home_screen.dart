import 'package:ckexhibitor/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 186, 219, 1),
      body: Container(
        width: size.width,
        height: size.height,
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
              SizedBox(
                height: 100,
              ),
              SizedBox(
                width: 295,
                height: 40,
                child: ElevatedButton(
                  child: Text("Scan qr code"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRCodeScannerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(42, 75, 157, 1)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
