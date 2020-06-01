import 'package:calculator_client/widgets/number_button.dart';
import 'package:flutter/material.dart';

import 'main_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<MainScreenState>(
          builder: (ctx, snapshot) {
            if (snapshot.data is MainScreenIntroState) {
              Future.delayed(Duration.zero, () {
              showDialog(
                  context: ctx,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return getIntroAlertDialog(ctx);
                  });
            });
            }
            return _buildCalc();
          },
          stream: bloc.state,
          initialData: MainScreenIntroState()),
    );
  }

  Widget _buildCalc() {
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          color: Color(0xFF9BA6FA),
          width: double.infinity,
          child: Text(
            "data.calculationValue",
            style: TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.end,
            textWidthBasis: TextWidthBasis.parent,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton("C", () => {}),
              flex: 2,
            ),
            Expanded(
              child: NumberButton("^", () => {}),
            ),
            Expanded(
              child: NumberButton("<", () => {bloc.removeLastDigit()}),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton("1", () => {bloc.addDigit("1")}),
            ),
            Expanded(
              child: NumberButton("2", () => {bloc.addDigit("2")}),
            ),
            Expanded(
              child: NumberButton("3", () => {bloc.addDigit("3")}),
            ),
            Expanded(
              child: NumberButton("+", () => {}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton("4", () => {bloc.addDigit("4")}),
            ),
            Expanded(
              child: NumberButton("5", () => {bloc.addDigit("5")}),
            ),
            Expanded(
              child: NumberButton("6", () => {bloc.addDigit("6")}),
            ),
            Expanded(
              child: NumberButton("-", () => {}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton("7", () => {bloc.addDigit("7")}),
            ),
            Expanded(
              child: NumberButton("8", () => {bloc.addDigit("8")}),
            ),
            Expanded(
              child: NumberButton("9", () => {bloc.addDigit("9")}),
            ),
            Expanded(
              child: NumberButton("*", () => {}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(".", () => {bloc.addDigit(".")}),
            ),
            Expanded(
              child: NumberButton("0", () => {bloc.addDigit("0")}),
            ),
            Expanded(
              child: NumberButton("=", () => {}),
            ),
            Expanded(
              child: NumberButton("/", () => {}),
            ),
          ],
        )
      ],
    ));
  }

  String userName = "";
  final introDialogTextEditingController = TextEditingController();
  AlertDialog getIntroAlertDialog(BuildContext context) {
    introDialogTextEditingController.addListener(() {
      userName = introDialogTextEditingController.text;
    });
    return AlertDialog(
      title: Text("Добро пожаловать"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                width: double.infinity,
                child: Text("Введите имя: ", textAlign: TextAlign.start)),
            TextField(
              controller: introDialogTextEditingController,
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            if (userName.isEmpty) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Выберите имя")));
              Future.delayed(Duration(seconds: 2), () {
                Scaffold.of(context).hideCurrentSnackBar();
              });
            } else {
              bloc.connect(userName);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
