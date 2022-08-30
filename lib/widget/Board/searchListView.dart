import 'package:dozn/widget/rowText.dart';
import 'package:flutter/material.dart';

Widget searchListView(List<String> searchList) {
  List<Widget> manufacturers =
      searchList.map((search) => rowText(search, 10)).toList();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: manufacturers,
    ),
  );
}
