import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  late Size size;
  //This one is DEBUG only REMEBER YOU IDIOT
  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? _controller;
  Barcode? result;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    _controller?.pauseCamera();
    _controller?.resumeCamera();
    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 186, 219, 1),
      body: Container(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset(
                "images/CKLogo.png",
                width: 250,
                height: 250,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: 260, height: 260, child: _buildQRView(context)),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _controller?.toggleFlash();
                          },
                          child: Icon(
                            Icons.flash_on,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _controller?.flipCamera();
                          },
                          child: Icon(
                            Icons.flip_camera_ios,
                            size: 24,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = 250.0;

    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
          cutOutSize: scanArea,
          borderWidth: 10,
          borderLength: 40,
          borderRadius: 5.0,
          borderColor: Color.fromRGBO(95, 186, 219, 1)),
    );
  }

  void _onQRViewCreated(QRViewController _qrController) {
    setState(() {
      this._controller = _qrController;
    });

    _controller?.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });
      if (result?.code != null) {
        print("QR Code Scanned and showing Result");
        _showResult();
      }
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController _ctrl, bool _permission) {
    if (!_permission) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No permission")));
    }
  }

  //Create a result view
  Widget _showResult() {
    return Center(
      child: FutureBuilder<dynamic>(
        future: showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                child: AlertDialog(
                  title: Text("Scan Result"),
                  content: SizedBox(
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(result!.code.toString()),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Close"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(42, 75, 157, 1)),
                          ),
                        ],
                      )),
                ),
                onWillPop: () async => false,
              );
            }),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          throw UnimplementedError;
        },
      ),
    );
  }
}
