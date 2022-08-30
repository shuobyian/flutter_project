import 'package:dozn/model/Board.dart';
import 'package:dozn/widget/columnText.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget boardMoreItemModal(BuildContext context, Board board) =>  TextButton(
  child: const Text('추가 정보'),
  onPressed: () {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                columnText('카테고리: ${board.category}', 10),
                columnText('출판사: ${board.company}', 10),
                columnText('게시일: ${board.dateTime}', 10),
                InkWell(
                    child: columnText('뉴스링크: ${board.newsLink}', 10),
                    onTap: () =>
                        launch(board.newsLink)),
                const SizedBox(height: 10),
                columnText(
                    '조회수: ${board.subscribeCount.toString()}',
                    10),
              ],
            ),
          ),
        );
      },
    );
  },
);