import 'package:flutter/material.dart';

Future deleteDialog(BuildContext context, void Function() onPressed) =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('게시글을 삭제하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: onPressed,
                child: const Text("확인"),
              ),
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
