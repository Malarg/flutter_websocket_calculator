import 'package:calculator_client/widgets/number_button.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
            color: Color(0xFF9BA6FA),
            width: double.infinity,
            child: Text(
              '100500',
              style: TextStyle(fontSize: 40, color: Colors.white),
              textAlign: TextAlign.end,
              textWidthBasis: TextWidthBasis.parent,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NumberButton("1", () => {}),
              ),
              Expanded(
                child: NumberButton("2", () => {}),
              ),
              Expanded(
                child: NumberButton("3", () => {}),
              ),
              Expanded(
                child: NumberButton("+", () => {}),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NumberButton("4", () => {}),
              ),
              Expanded(
                child: NumberButton("5", () => {}),
              ),
              Expanded(
                child: NumberButton("6", () => {}),
              ),
              Expanded(
                child: NumberButton("-", () => {}),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NumberButton("7", () => {}),
              ),
              Expanded(
                child: NumberButton("8", () => {}),
              ),
              Expanded(
                child: NumberButton("9", () => {}),
              ),
              Expanded(
                child: NumberButton("*", () => {}),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NumberButton(".", () => {}),
              ),
              Expanded(
                child: NumberButton("0", () => {}),
              ),
              Expanded(
                child: NumberButton("/", () => {}),
              ),
              Expanded(
                child: NumberButton("^", () => {}),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NumberButton("C", () => {}),
              ),
              Expanded(
                child: NumberButton("=", () => {}),
              )
            ],
          )
        ],
      )),
    );
  }
}
