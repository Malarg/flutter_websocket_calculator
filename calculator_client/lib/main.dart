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
  final bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<SnackData>(
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                _showSnack(context, snapshot.data);
              }
              return StreamBuilder<MainScreenState>(
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
                  stream: bloc.stateStream,
                  initialData: MainScreenIntroState());
            },
            stream: bloc.snackStream));
  }

  void _showSnack(BuildContext context, SnackData data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(data.snackMessage),
        action: SnackBarAction(
          label: data.snackActionText ?? "",
          onPressed: data.snackAction ?? () {},
        ),
      ));

      if (data.shouldHideSnack) {
        Future.delayed(Duration(seconds: 2), () {
          Scaffold.of(context).hideCurrentSnackBar();
        });
      }
    });
  }

  Widget _buildCalc() {
    ScrollController _scrollController = ScrollController();
    return Column(
      children: <Widget>[
        StreamBuilder<List<CalculationHistory>>(
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
                    return CalculationHistoryWidget(
                        historySnapshot.data[index]);
                  }),
            );
          },
          stream: bloc.historyStream,
          initialData: [],
        ),
        StreamBuilder<String>(
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
          stream: bloc.calculationValueStream,
          initialData: Strings.ZERO,
        ),
        StreamBuilder<bool>(
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
                                      bloc.setCalculationType(
                                          CalculationType.zero);
                                      bloc.calculate();
                                    }
                                  : null),
                          flex: 2,
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.POW,
                              calculationsEnabledSnapshot.data
                                  ? () => {
                                        bloc.setCalculationType(
                                            CalculationType.pow)
                                      }
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.BACK,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.removeLastDigit()}
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
                                  ? () => {bloc.addDigit(Strings.ONE)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.TWO,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.TWO)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.THREE,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.THREE)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.PLUS,
                              calculationsEnabledSnapshot.data
                                  ? () => {
                                        bloc.setCalculationType(
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
                                  ? () => {bloc.addDigit(Strings.FOUR)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.FIVE,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.FIVE)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.SIX,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.SIX)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.MINUS,
                              calculationsEnabledSnapshot.data
                                  ? () => {
                                        bloc.setCalculationType(
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
                                  ? () => {bloc.addDigit(Strings.SEVEN)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.EIGHT,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.EIGHT)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.NINE,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.NINE)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.MULTIPLY,
                              calculationsEnabledSnapshot.data
                                  ? () => {
                                        bloc.setCalculationType(
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
                                  ? () => {bloc.addDigit(Strings.DOT)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.ZERO,
                              digitsEnabledSnapshot.data
                                  ? () => {bloc.addDigit(Strings.ZERO)}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.EQUALS,
                              calculationsEnabledSnapshot.data
                                  ? () => {bloc.calculate()}
                                  : null),
                        ),
                        Expanded(
                          child: NumberButton(
                              Strings.DIVIDE,
                              calculationsEnabledSnapshot.data
                                  ? () => {
                                        bloc.setCalculationType(
                                            CalculationType.divide)
                                      }
                                  : null),
                        ),
                      ],
                    )
                  ],
                ));
              },
              stream: bloc.areCalculationsEnabledStream,
              initialData: false,
            );
          },
          stream: bloc.areDigitsEnabledStream,
          initialData: false,
        )
      ],
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
                  // todo это логика
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
        ),
        onWillPop: () {});
  }
}
