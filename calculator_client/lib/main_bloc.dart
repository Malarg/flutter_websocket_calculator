import 'dart:async';

import 'dart:convert';

import 'package:calculation_core/calculation_core.dart';
import 'package:calculator_client/strings.dart';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';

class MainBloc {
  final _stateStreamController = StreamController<MainScreenState>();
  Stream<MainScreenState> get state => _stateStreamController.stream;
  
  IOWebSocketChannel channel;

  var data = MainScreenState();

  void connect(String name) async {
    channel = IOWebSocketChannel.connect("ws://192.168.1.9:8888/connect", headers: {"Authorization": "Bearer $name"});
    channel.stream.listen((event) {
      final map = json.decode(event) as Map<String, dynamic>;
      
      final isUser = map.containsKey("name"); //TODO прогуглить нормальный способ определения
      if (isUser) {
        data.user = User.fromJson(map);
        print("user $event parsed");
      }
      
      final isCalculationResult = map.containsKey("calculationType");
      if (isCalculationResult) {
        final calculationResult = CalculationHistory.fromJson(map);
        data.calculationValue = calculationResult.result.toString();
        data.isResultDisplayed = true;
        data.history.add(calculationResult);
        _stateStreamController.add(data);
      }

      final isErrorMessage = map.containsKey("message");
      if (isErrorMessage) {
        ErrorMessage message = ErrorMessage.fromJson(map);
        _showSnack(message.message, true, null, null);
      }
      print(event);
    });
    channel.sink.add(json.encode(User.named(name).toJson()));
    _stateStreamController.add(MainScreenDataState());
    print(channel);
  }

  void addDigit(String digit) {
    if (data.calculationValue.contains(Strings.DOT) && digit == Strings.DOT) {
      return;
    }
    if (data.isResultDisplayed) {
      data.calculationValue = digit == Strings.DOT && data.calculationValue.isEmpty ? "0." : digit;
      data.isResultDisplayed = false;
    } else {
      if (data.calculationValue == Strings.ZERO) {
        data.calculationValue = digit;
      } else {
        data.calculationValue += digit == Strings.DOT && data.calculationValue.isEmpty ? "0." : digit;
      }
    }
    _stateStreamController.sink.add(data);
  }

  void setCalculationType(CalculationType calculationType) {
    data.calculationType = calculationType;
    _stateStreamController.sink.add(data);
    if (data.isResultDisplayed) {
      return;
    }
    calculate();
  }

  void calculate() {
    final calculationJson = CalculationRequest(data.user?.id ?? 0, data.calculationType, double.parse(data.calculationValue)).toJson();
    final jsonValue = json.encode(calculationJson);
    print(jsonValue);
    channel.sink.add(jsonValue);
  }

  void _showSnack(String message, bool shouldHide, VoidCallback action, String actionText) {
    data.snackMessage = message;
    data.shouldHideSnack = shouldHide;
    data.snackAction = action;
    data.snackActionText = actionText;
    _stateStreamController.sink.add(MainScreenErrorState(data));


  }

  void removeLastDigit() {
    if (data.isResultDisplayed) {
      return;
    }
    if (data.calculationValue.length <= 1) {
      data.calculationValue = Strings.ZERO;
    } else {
      data.calculationValue = data.calculationValue.substring(0, data.calculationValue.length - 1);
    }
    _stateStreamController.sink.add(data);
  }

  void dispose() {
    _stateStreamController.close();
  }
}

/*
  Требования к классу для ошибок
  1. Должно быть поле для текста
  2. Должен быть action
  3. Должен быть выбор - показать на пару секунд или оставить надолго. При тапе на action при этом, поле должно скрываться.
  4. Должно быть удобно работать с этим всем. 
*/
class MainScreenState {
  String snackMessage;
  bool shouldHideSnack;
  VoidCallback snackAction;
  String snackActionText;

  User user;
  List<CalculationHistory> history = [];
  CalculationType calculationType;
  String calculationValue = Strings.ZERO;
  bool isResultDisplayed = true;
}

class MainScreenDataState extends MainScreenState {
  
}

class MainScreenIntroState extends MainScreenState {

}

class MainScreenErrorState extends MainScreenState {
  MainScreenErrorState(MainScreenState state) {
    this.snackMessage = state.snackMessage;
    this.shouldHideSnack = state.shouldHideSnack;
    this.snackAction = state.snackAction;
    this.snackActionText = state.snackActionText;

    this.user = state.user;
    this.history = state.history;
    this.calculationType = state.calculationType;
    this.calculationValue = state.calculationValue;
    this.isResultDisplayed = state.isResultDisplayed;
  }
}