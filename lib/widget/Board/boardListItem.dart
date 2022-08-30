import 'package:dozn/model/Board.dart';
import 'package:flutter/material.dart';

Widget boardListItem(BuildContext context, Board board) => Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      board.content),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 0),
                alignment: const Alignment(1.0, 1.0),
                child: Text(board.username))
          ],
        ),
      ),
    );
