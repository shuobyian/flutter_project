import 'package:flutter/material.dart';

Widget columnText(String text, double height, [TextStyle? textStyle]) => Column(
      children: [
        Text(
          text,
          style: textStyle,
        ),
        SizedBox(height: height)
      ],
    );
