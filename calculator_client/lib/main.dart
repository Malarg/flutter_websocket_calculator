import 'package:calculation_core/calculation_core.dart';
import 'package:calculator_client/strings.dart';
import 'package:calculator_client/widgets/item_history.dart';
import 'package:calculator_client/widgets/number_button.dart';
import 'package:flutter/material.dart';

import 'main_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: Strings.CALCULATOR),
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
  final _bloc = MainBloc();
  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.snackStream.listen((snackData) {
      _showSnack(snackData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
            stream: _bloc.stateStream,
            initialData: MainScreenIntroState()));
  }

  void _showSnack(SnackData data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(data.snackMessage)));
      Future.delayed(Duration(seconds: 2), () {
        _scaffoldKey.currentState.hideCurrentSnackBar();
      });
    });
  }

  Widget _buildCalc() {
    return Column(
      children: <Widget>[
        _buildHistoryList(),
        _buildCalculationValueText(),
        _buildButtons()
      ],
    );
  }

  StreamBuilder<List<CalculationHistory>> _buildHistoryList() {
    return StreamBuilder<List<CalculationHistory>>(
      builder: (context, historySnapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        });
        return Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              controller: _scrollController,
              itemCount: historySnapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CalculationHistoryWidget(historySnapshot.data[index]);
              }),
        );
      },
      stream: _bloc.historyStream,
      initialData: [],
    );
  }

  StreamBuilder<String> _buildCalculationValueText() {
    return StreamBuilder<String>(
      builder: (context, valueSnapshot) {
        return Container(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          color: Color(0xFF9BA6FA),
          width: double.infinity,
          child: Text(
            valueSnapshot.data,
            style: TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.end,
            textWidthBasis: TextWidthBasis.parent,
            maxLines: 1,
          ),
        );
      },
      stream: _bloc.calculationValueStream,
      initialData: Strings.ZERO,
    );
  }

  StreamBuilder<bool> _buildButtons() {
    return StreamBuilder<bool>(
      builder: (context, digitsEnabledSnapshot) {
        return StreamBuilder<bool>(
          builder: (context, calculationsEnabledSnapshot) {
            return Center(
                child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberButton(
                          Strings.C,
                          calculationsEnabledSnapshot.data
                              ? () {
                                  _bloc
                                      .setCalculationType(CalculationType.zero);
                                  _bloc.calculate();
                                }
                              : null),
                      flex: 2,
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.POW,
                          calculationsEnabledSnapshot.data
                              ? () => {
                                    _bloc
                                        .setCalculationType(CalculationType.pow)
                                  }
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.BACK,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.removeLastDigit()}
                              : null),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberButton(
                          Strings.ONE,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.ONE)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.TWO,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.TWO)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.THREE,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.THREE)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.PLUS,
                          calculationsEnabledSnapshot.data
                              ? () => {
                                    _bloc.setCalculationType(
                                        CalculationType.plus)
                                  }
                              : null),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberButton(
                          Strings.FOUR,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.FOUR)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.FIVE,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.FIVE)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.SIX,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.SIX)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.MINUS,
                          calculationsEnabledSnapshot.data
                              ? () => {
                                    _bloc.setCalculationType(
                                        CalculationType.minus)
                                  }
                              : null),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberButton(
                          Strings.SEVEN,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.SEVEN)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.EIGHT,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.EIGHT)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.NINE,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.NINE)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.MULTIPLY,
                          calculationsEnabledSnapshot.data
                              ? () => {
                                    _bloc.setCalculationType(
                                        CalculationType.multiply)
                                  }
                              : null),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberButton(
                          Strings.DOT,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.DOT)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.ZERO,
                          digitsEnabledSnapshot.data
                              ? () => {_bloc.addDigit(Strings.ZERO)}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.EQUALS,
                          calculationsEnabledSnapshot.data
                              ? () => {_bloc.calculate()}
                              : null),
                    ),
                    Expanded(
                      child: NumberButton(
                          Strings.DIVIDE,
                          calculationsEnabledSnapshot.data
                              ? () => {
                                    _bloc.setCalculationType(
                                        CalculationType.divide)
                                  }
                              : null),
                    ),
                  ],
                )
              ],
            ));
          },
          stream: _bloc.areCalculationsEnabledStream,
          initialData: false,
        );
      },
      stream: _bloc.areDigitsEnabledStream,
      initialData: false,
    );
  }

  String userName = "";
  final introDialogTextEditingController = TextEditingController();
  Widget getIntroAlertDialog(BuildContext context) {
    introDialogTextEditingController.addListener(() {
      userName = introDialogTextEditingController.text;
    });
    return WillPopScope(
        child: AlertDialog(
          title: Text("Добро пожаловать"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: Text(Strings.TYPE_NAME, textAlign: TextAlign.start)),
                TextField(
                  controller: introDialogTextEditingController,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(Strings.OK),
              onPressed: () {
                if (userName.isEmpty) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(Strings.SELECT_NAME)));
                  Future.delayed(Duration(seconds: 2), () {
                    Scaffold.of(context).hideCurrentSnackBar();
                  });
                } else {
                  _bloc.connect(userName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        onWillPop: () {});
  }
}
