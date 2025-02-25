import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Container(
          width: 55,
          height: 55,
          child: Image.asset('assets/pharmacy_logo.png'),
        ),
        h1("Dashboard", color: Colors.white)
      ],
    );
  }
}
