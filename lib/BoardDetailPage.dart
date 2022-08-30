import 'package:dozn/model/Board.dart';
import 'package:dozn/model/BoardHelper.dart';
import 'package:dozn/widget/Board/boardMoreItem.dart';
import 'package:dozn/widget/Board/boardMoreItemModal.dart';
import 'package:dozn/widget/columnText.dart';
import 'package:flutter/material.dart';

class BoardDetailPage extends StatefulWidget {
  final Board board;

  const BoardDetailPage({Key? key, required this.board}) : super(key: key);

  @override
  State<BoardDetailPage> createState() => BoardDetailPageState();
}

class BoardDetailPageState extends State<BoardDetailPage> {
  late final Board board;
  final BoardHelper _boardHelper = BoardHelper();

  Future _getBoard() async {
    board = await _boardHelper.readDetail(widget.board.id ?? 0);
  }

  @override
  void initState() {
    super.initState();
    _getBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      columnText(
                          widget.board.username, 5, const TextStyle(fontSize: 20)),
                      const Spacer(),
                      MediaQuery.of(context).size.width < 600
                          ? boardMoreItemModal(context, widget.board)
                          : Container(),
                    ],
                  ),
                  columnText(
                    widget.board.title,
                    5,
                    const TextStyle(fontSize: 32),
                  ),
                  columnText(
                    widget.board.content,
                    5,
                    const TextStyle(fontSize: 16),
                  ),
                  Image(
                      image: NetworkImage(
                        widget.board.imageUrl,
                      )),
                ],
              ),
              MediaQuery.of(context).size.width >= 600
                  ? boardMoreItem(widget.board)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
