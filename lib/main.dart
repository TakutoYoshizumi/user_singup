import 'package:flutter/material.dart';

import './user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  List<User> users = [];
  List<String> _validate = [];
  String? errorMessage = ""; //エラーメッセージ

  //ユーザーを登録するメソッド
  void addUser(String text) {
    int i = users.length; //ユーザーid
    final User newUser = User(text, i);
    //userの0番目に新しいタスクを追加
    users.add(newUser);
    //入力フォームの値をリセット
    myController.clear();
    errorMessage = "";
    // SetStateを行うことによってWidgetの内容を更新
    setState(() {});
  }

  //類似している登録名があるかチェックするメソッド
  //入力された（引数）の値をチェック
  checkUser(String text) {
    //配列にユーザーが一人もいなければ登録
    if (users.length == 0) {
      addUser(text);
    } else {
      _validate = []; //エラーを入れる配列

      //usersにユーザーがいれば、類似するユーザーがいるかnameをチェック
      //類似するユーザーがいる場合、_validateにerrorを格納
      for (var val in users) {
        if (val.name == text) {
          String error = "false";
          _validate.add(error);
        }
      }
    }
    return _validate;
  }

  showMessage() {
    errorMessage = "";
    if ((checkUser(myController.text).length) != 0) {
      errorMessage = "入力されたユーザーはすべに登録されています。";
    }
    myController.clear();
    return errorMessage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Login"),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 100),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: _form(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              //ユーザー登録チェックメソッド
                              checkUser(myController.text);
                              print(checkUser(myController.text).length);
                              //類似するユーザー名が登録している場合、エラーメッセージ表示
                              (checkUser(myController.text).length) == 0
                                  ? addUser(myController.text)
                                  : showMessage();
                            }
                          });
                        },
                        child: const Text('登録'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('ログイン'),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child:
                        //エラーメッセージ
                        Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$errorMessage",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  _form() {
    return Column(
      children: [
        Container(
            child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: myController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '名前を入力してください',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ))),
      ],
    );
  }
}
