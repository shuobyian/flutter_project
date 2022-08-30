import 'package:flutter/material.dart';

Widget rowText(String text, double width, [TextStyle? textStyle]) => Row(
  children: [
    Text(
      text,
      style: textStyle,
    ),
    SizedBox(width: width)
  ],
);
