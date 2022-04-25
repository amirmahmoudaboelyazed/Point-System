import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:test_project/Printer/printer.dart';
import 'dart:io';

import 'ImagestorByte.dart';
import 'item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  String dir = Directory.current.path;
  double? width;
  double? widthPhoto;
  double? containerWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(dir);
    setState(() {
      Process.run('$dir/images/installerX64/install.exe', [' start '])
          .then((ProcessResult results) {
        print("port poen");
      });
    });
  }

  void testPrint(String printerIp, Uint8List theimageThatComesfr) async {
    print("im inside the test print 2");
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
    await printer.connect('192.168.1.107', port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await testReceiptWifi(printer, theimageThatComesfr);
      print(res.msg);
      await Future.delayed(const Duration(seconds: 3), () {
        print("prinnter desconect");
        printer.disconnect();
      });
    }
  }

  TextEditingController Printer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    if (aspectRatio <= 0.45) {
      width = 7;
      widthPhoto = 60;
      containerWidth = 150;
    } else if (aspectRatio > 0.45 && aspectRatio < 0.47) {
      width = 9;
      containerWidth = 250;
      widthPhoto = 75;
    } else if (aspectRatio < 0.47 && aspectRatio < 0.49) {
      width = 12;
      containerWidth = 350;
      widthPhoto = 80;
    } else {
      width = 13;
      containerWidth = 380;
      widthPhoto = 90;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("معاينة الوصل قبل الطباعة "),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              TextField(
                controller: Printer,
                decoration: const InputDecoration(hintText: "printer ip"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text(
                  'print res',
                  style: const TextStyle(fontSize: 40),
                ),
                onPressed: () {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    theimageThatComesfromThePrinter = capturedImage!;
                    setState(() {
                      theimageThatComesfromThePrinter = capturedImage;
                      testPrint(Printer.text, theimageThatComesfromThePrinter);
                    });
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  //color: Colors.grey,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [

                            Container(
                                width: containerWidth,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //   "مخبز حسام سعيد",
                                      //   style: TextStyle(
                                      //       fontSize: width! + 4,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      //
                                      // Text(
                                      //   "عملية بيع ناجحة",
                                      //   style: TextStyle(
                                      //       fontSize: width,
                                      //       fontWeight: FontWeight.bold),
                                      // ),

                                      Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "مخبز حسام سعيد",
                                            style: TextStyle(
                                                fontSize: width,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text(
                                            "عملية بيع ناجحة",
                                            style: TextStyle(
                                                fontSize: width,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "رقم:1235",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      "الرئيسي -الاداره",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      " تاريخ : 29/3/2022",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      " 03:19 PM",
                                                      style: TextStyle(
                                                          fontSize: width,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "أمير محمود ابو اليزيد",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "5",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "فرد",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "حصة الشهر :    775",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "رصيد سابق : 600",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "المجموع     1,375      نقطة",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "مستهلك قبل العملية  59,550   نقطة",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              "الصنف",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "العملية",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "الاجمالي",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: 3,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return orderItem(
                                                " ارز", "1", "20", width);
                                          }),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              "الاجمالي",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "60",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "مستهلك بعد العملية  59,550   نقطة",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "باقي من السابق : 0",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "باقي من الحالي : 600",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1)),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              "المبلغ المدفوع",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "120 ج م",
                                              style: TextStyle(
                                                  fontSize: width,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
