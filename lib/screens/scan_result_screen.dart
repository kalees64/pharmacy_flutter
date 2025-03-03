import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen(
      {super.key, required this.qrResult, required this.qrResultImage});

  final dynamic qrResult;
  final dynamic qrResultImage;

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Scan Result"),
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h2("Result:"),
                  Text(
                    widget.qrResult.toString(),
                  ),
                  Image(
                    image: MemoryImage(widget.qrResultImage),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
