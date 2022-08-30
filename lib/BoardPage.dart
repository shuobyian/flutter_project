import 'dart:async';
import 'dart:convert';

import 'package:dozn/BoardDetailPage.dart';
import 'package:dozn/CreateBoardPage.dart';
import 'package:dozn/model/Board.dart';
import 'package:dozn/model/BoardHelper.dart';
import 'package:dozn/widget/Board/boardListItem.dart';
import 'package:dozn/widget/Board/searchListView.dart';
import 'package:dozn/widget/deleteDialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => BoardPageState();
}

List<Board> parseBoards(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed['data'].map<Board>((json) => Board.fromJson(json)).toList();
}

class BoardPageState extends State<BoardPage> {
  List<String> searchList = [];
  late SharedPreferences _prefs;

  final searchController = TextEditingController();

  _loadSearch() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      searchList = (_prefs.getStringList('searches') ?? []);
    });
  }

  _saveSearch(String search) async {
    setState(() {
      if (search.isNotEmpty) {
        if (searchList.length < 5) {
          searchList = [...(_prefs.getStringList('searches') ?? []), search];
        } else {
          searchList.removeAt(0);
          searchList = [...searchList, search];
        }
        _prefs.setStringList('searches', searchList);
      }
    });
  }

  List<Board> rawBoardList = [];
  List<Board> boardList = [];

  final BoardHelper _boardHelper = BoardHelper();

  Future _getBoards() async {
    boardList = await _boardHelper.read();
    rawBoardList = await _boardHelper.read();
  }

  Future _initData(Board board) async {
    await _boardHelper.createInit(board);
  }

  Future _updateSubscribeCount(Board board) async {
    await _boardHelper.updateSubscribeCount(board);
  }

  Future _deleteBoard(Board board) async {
    await _boardHelper.delete(board);
  }

  Future _callAPI() async {
    var flag = await _boardHelper.readInitDB();
    final url = Uri.parse(
        'https://raw.githubusercontent.com/doznAvokado/flutter_web_task/master/data.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (flag.length < 1) {
        List<Board> list = parseBoards(response.body);
        for (var board in list) {
          _initData(board);
        }
        _boardHelper.createInitDB();
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  void _init() async {
    await _callAPI();
    Timer(Duration(seconds: 1), () {
      _getBoards();
      _loadSearch();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  @protected
  void didUpdateWidget(BoardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시판'), actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CreateBoardPage()))
                .then((value) {
              setState(() {
                _getBoards();
              });
            });
          },
          child: const Text(
            '생성',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                textInputAction: TextInputAction.search,
                controller: searchController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _saveSearch(searchController.text);
                          if (searchController.text.isEmpty) {
                            _getBoards();
                          } else {
                            boardList = rawBoardList
                                .where((board) =>
                                    board.title
                                        .contains(searchController.text) ||
                                    board.content
                                        .contains(searchController.text))
                                .toList();
                          }
                        },
                        icon: const Icon(Icons.search)),
                    border: const OutlineInputBorder(),
                    hintText: '검색어를 입력해주세요.')),
          ),
          searchListView(searchList),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: boardList.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey, // background
                      onPrimary: Colors.black, // foreground
                    ),
                    onLongPress: () {
                      deleteDialog(context, () async {
                        _deleteBoard(boardList[index]).then((value) {
                          setState(() {
                            _getBoards();
                          });
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('삭제되었습니다.'),
                        ));
                        Navigator.pop(context);
                      });
                    },
                    onPressed: () {
                      _updateSubscribeCount(boardList[index]);
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BoardDetailPage(board: boardList[index])))
                          .then((value) {
                        setState(() {
                          _getBoards();
                        });
                      });
                    },
                    child: boardListItem(context, boardList[index]));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
        ],
      ),
    );
  }
}
