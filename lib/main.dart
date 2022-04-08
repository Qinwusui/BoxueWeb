import 'dart:ui';

import 'package:boxueweb/BookDetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '博学题库',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: const Text('博学题库'),
        ),
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<BookList> snapshot) {
            if (snapshot.hasData) {
              List<Widget> _list = [];
              var data = snapshot.data?.bookList;
              //
              for (int i = 0; i < data!.length; i++) {
                var name = data[i];
                _list.add(GestureDetector(
                    child: ListTile(
                      title: Text(
                        data[i],
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(name),
                      leading: const Icon(
                        Icons.book,
                        color: Colors.pinkAccent,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          FToast s = FToast();
                          s.init(context);
                          Widget toast = Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.redAccent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.error),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text("可是这个人没有写收藏功能.."),
                              ],
                            ),
                          );
                          s.showToast(
                              child: toast,
                              gravity: ToastGravity.TOP,
                              toastDuration: const Duration(seconds: 3));
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BookView(bookName: name);
                      }));
                    }));
              }
              return ListView(
                children: _list,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          future: getBookList(),
        ),
      ),
    );
  }
}

class BookView extends StatefulWidget {
  final String bookName;

  const BookView({Key? key, required this.bookName}) : super(key: key);

  @override
  _BookView createState() => _BookView();
}

class _BookView extends State<BookView> {
  String w = "";

  @override
  Widget build(BuildContext context) {
    FToast s = FToast();
    s.init(context);

    return MaterialApp(
      title: widget.bookName,
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pinkAccent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(widget.bookName),
          ),
          body: FutureBuilder(
              future: getBookDetail(widget.bookName),
              builder:
                  (BuildContext context, AsyncSnapshot<BookDetail> snapshot) {
                //请求完成

                if (snapshot.hasData) {
                  var data = snapshot.data!.bookDetail;
                  //请求成功，通过项目信息构建用于显示项目名称的ListView
                  List<Widget> _list = [];
                  for (int i = 0; i < data.length; i++) {
                    var question = data[i].split("??")[0];
                    var answers = data[i].split("??")[1];
                    List<Widget> li = [];
                    var answer = answers.split("||");
                    for (int j = 0; j < answer.length; j++) {
                      if (answer[j].contains("_")) {
                        li.add(TextButton(
                          child: Text(
                            answer[j].replaceAll("_", ""),
                            style: const TextStyle(color: Colors.teal),
                          ),
                          onPressed: () {
                            s.showToast(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Colors.teal,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.panorama_fish_eye),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text("回答正确！"),
                                    ],
                                  ),
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 1));
                          },
                        ));
                      } else {
                        li.add(TextButton(
                          onPressed: () {
                            setState(() {
                              w = "回答错误！";
                            });
                            s.showToast(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Colors.redAccent,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.error),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text("回答错误！"),
                                    ],
                                  ),
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 1));
                          },
                          child: Text(
                            answer[j].replaceAll("_", ""),
                            style: const TextStyle(color: Colors.black38),
                          ),
                        ));
                      }
                      if (j != answer.length - 1) {
                        li.add(const Padding(
                            padding: EdgeInsets.only(bottom: 10)));
                      }
                    }
                    _list.add(GestureDetector(
                        child: ListTile(
                      title: Text("${i + 1}.  $question"),
                      subtitle: Center(
                        child: Column(
                          children: li,
                        ),
                      ),
                    )));
                    if (i != data.length - 1) {
                      _list.add(const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ));
                    }
                  }
                  return ListView(
                    children: _list,
                  );
                }
                //请求未完成时弹出loading
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}

Future<BookList> getBookList() async {
  Response res;
  var dio = Dio();
  res = await dio.get("");
  //TODO 写上自己的后端服务器的IP
  BookList bookList = BookList.fromJson(res.data);
  return bookList;
}

Future<BookDetail> getBookDetail(String name) async {
  Response res;
  var dio = Dio();
  dio.options.connectTimeout = 20 * 1000;
  dio.options.receiveTimeout = 20 * 1000;
  dio.options.sendTimeout = 20 * 1000;
  // print();
  res = await dio.get("");
  //TODO 写上自己的后端服务器的IP

  BookDetail bookDetail = BookDetail.fromJson(res.data);
  return bookDetail;
}

class BookList {
  final List<dynamic> bookList;

  BookList({required this.bookList});

  factory BookList.fromJson(Map<String, dynamic> json) =>
      BookList(bookList: json['bookList']);
}
