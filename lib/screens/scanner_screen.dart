import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/screens/scan_result_screen.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Scanner"),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                if (barcodes.isNotEmpty && image != null) {
                  await _controller.stop();
                  if (mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanResultScreen(
                          qrResult: barcodes.first.rawValue,
                          qrResultImage: image,
                        ),
                      ),
                    );
                    _controller.start();
                  }
                }
              },
            ),
            Positioned(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 250,
                    height: 4,
                    margin: EdgeInsets.only(top: _animation.value * 250),
                    color: primaryColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
