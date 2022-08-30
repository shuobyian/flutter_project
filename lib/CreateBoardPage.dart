import 'package:dozn/model/BoardHelper.dart';
import 'package:dozn/widget/rowText.dart';
import 'package:flutter/material.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key? key}) : super(key: key);

  @override
  State<CreateBoardPage> createState() => CreateBoardPageState();
}

class CreateBoardPageState extends State<CreateBoardPage> {
  final formKey = GlobalKey<FormState>();

  String title = '';
  String content = '';
  String category = '';

  late List<String> categoryList = ['금융', 'IT', '보안'];
  late List<bool> isSelected = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 생성'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                onSaved: (val) {
                  setState(() {
                    title = val!;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return '제목을 입력해주세요.';
                  }
                  if (val.length > 15) {
                    return '15자 이하로 입력해주세요.';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: "제목"),
              ),
              TextFormField(
                onSaved: (val) {
                  setState(() {
                    content = val!;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return '내용을 입력해주세요.';
                  }
                  if (val.length > 300) {
                    return '15자 이하로 입력해주세요.';
                  }
                  return null;
                },
                maxLines: 5,
                minLines: 3,
                decoration: const InputDecoration(labelText: "내용"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  rowText('카테고리', 10),
                  ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          category = categoryList[index];
                          for (int i = 0; i < isSelected.length; i++) {
                            if (index == i) {
                              isSelected[i] = true;
                            } else {
                              isSelected[i] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                      children: categoryList
                          .map((category) => Text(category))
                          .toList()),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: const Text('생성'),
                  onPressed: () async => {
                    if (formKey.currentState!.validate())
                      {
                        formKey.currentState!.save(),
                        BoardHelper()
                            .create(title, content, category),
                        Navigator.pop(context)
                      }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
