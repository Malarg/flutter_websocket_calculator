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
      body: StreamBuilder<MainScreenState>(
          builder: (ctx, snapshot) {
            _handleError(ctx, snapshot.data);
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
            return _buildCalc(snapshot.data);
          },
          stream: bloc.state,
          initialData: MainScreenIntroState()),
    );
  }

  void _handleError(BuildContext context, MainScreenState state) {
    if (!(state is MainScreenErrorState)) {
      return;
    }
    final errorState = state as MainScreenErrorState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(errorState.snackMessage),
        action: SnackBarAction(
          label: errorState.snackActionText ?? "",
          onPressed: errorState.snackAction ?? () {},
        ),
      ));

      if (errorState.shouldHideSnack) {
        Future.delayed(Duration(seconds: 2), () {
          Scaffold.of(context).hideCurrentSnackBar();
        });
      }
    });
  }

  Widget _buildCalc(MainScreenState state) {
    ScrollController _scrollController = ScrollController();
    final isNumberButtonEnabled = state is MainScreenState &&
        (!state.isResultDisplayed || state.calculationType != null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
    return Center(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              controller: _scrollController,
              itemCount: state.history.length,
              itemBuilder: (BuildContext context, int index) {
                return CalculationHistoryWidget(state.history[index]);
              }),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          color: Color(0xFF9BA6FA),
          width: double.infinity,
          child: Text(
            state.calculationValue,
            style: TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.end,
            textWidthBasis: TextWidthBasis.parent,
            maxLines: 1,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(Strings.C,
                  () {bloc.setCalculationType(CalculationType.zero); bloc.calculate();}),
              flex: 2,
            ),
            Expanded(
              child: NumberButton(Strings.POW,
                  () => {bloc.setCalculationType(CalculationType.pow)}),
            ),
            Expanded(
              child: NumberButton(Strings.BACK, () => {bloc.removeLastDigit()}),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(
                  Strings.ONE,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.ONE)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.TWO,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.TWO)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.THREE,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.THREE)}
                      : null),
            ),
            Expanded(
              child: NumberButton(Strings.PLUS,
                  () => {bloc.setCalculationType(CalculationType.plus)}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(
                  Strings.FOUR,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.FOUR)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.FIVE,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.FIVE)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.SIX,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.SIX)}
                      : null),
            ),
            Expanded(
              child: NumberButton(Strings.MINUS,
                  () => {bloc.setCalculationType(CalculationType.minus)}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(
                  Strings.SEVEN,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.SEVEN)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.EIGHT,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.EIGHT)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.NINE,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.NINE)}
                      : null),
            ),
            Expanded(
              child: NumberButton(Strings.MULTIPLY,
                  () => {bloc.setCalculationType(CalculationType.multiply)}),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: NumberButton(
                  Strings.DOT,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.DOT)}
                      : null),
            ),
            Expanded(
              child: NumberButton(
                  Strings.ZERO,
                  isNumberButtonEnabled
                      ? () => {bloc.addDigit(Strings.ZERO)}
                      : null),
            ),
            Expanded(
              child: NumberButton(Strings.EQUALS, () => {bloc.calculate()}),
            ),
            Expanded(
              child: NumberButton(Strings.DIVIDE,
                  () => {bloc.setCalculationType(CalculationType.divide)}),
            ),
          ],
        )
      ],
    ));
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
