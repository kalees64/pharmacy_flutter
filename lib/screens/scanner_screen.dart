// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Scanner"),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // h1("QR Scan"),
              Expanded(
                  child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  // returnImage: true,
                ),
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  // final Uint8List? image = capture.image;
                  for (final barcode in barcodes) {
                    print("Barcode found : ${barcode.rawValue}");
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         title: Text(barcode.rawValue ?? ''),
                    //       );
                    //     });
                  }

                  // if (image != null) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //           title: Text(barcodes.first.rawValue ?? ''),
                  //         );
                  //       });
                  // }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
