import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:screenshot/screenshot.dart';

class TestPrinter extends StatefulWidget {
  @override
  _TestPrinterState createState() => _TestPrinterState();
}

class _TestPrinterState extends State<TestPrinter> {
  @override
  void initState() {
    setConnect();
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;
  bool connected = false;



  Future<void> setConnect() async {
    final String? result =
    await BluetoothThermalPrinter.connect("DC:0D:30:C0:7E:07");
    print("state connected $result");
    if (result == "true") {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      print("Print Error");
    }
  }

  Future<List<int>> getTicket() async {
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    //Print Image//
    final im.Image? image = im.decodeImage(_imageFile!);
    //////////////////////
    bytes += generator.image(image!);
    bytes += generator.feed(5);
    return bytes;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Thermal Printer Demo'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    screenshotController.capture().then((Uint8List? image) {
                      setState(() {
                        _imageFile = image;
                      });
                    }).catchError((onError) {
                      print(onError);
                    });
                    Future.delayed(Duration(milliseconds: 250), () {
                      printTicket();
                    });
                    refresh();
                  },
                  child: Text("Print Ticket"),
                ),
              ),
              Opacity(
                opacity: 1,
                child: Screenshot(
                  controller: screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black, width: 1)),
                            child: Text("أمير محمود ابو اليزيد رمضان  ")),
                        Text(" Mobile Developer"),
                        Text("01111871517"),
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
}
