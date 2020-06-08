import 'dart:async';

import 'dart:convert';

import 'package:calculation_core/calculation_core.dart';
import 'package:calculator_client/strings.dart';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';

class MainBloc {
  final _stateStreamController = StreamController<MainScreenState>();
  Stream<MainScreenState> get stateStream => _stateStreamController.stream;

  final _areDigitsButtonsEnabledStreamController = StreamController<bool>();
  Stream<bool> get areDigitsEnabledStream =>
      _areDigitsButtonsEnabledStreamController.stream;

  final _areCalculationsButtonsEnabledStreamController =
      StreamController<bool>();
  Stream<bool> get areCalculationsEnabledStream =>
      _areCalculationsButtonsEnabledStreamController.stream;

  List<CalculationHistory> _historyList = [];
  List<CalculationHistory> get history => _historyList;
  set history(List<CalculationHistory> value) {
    _historyList = value;
    _historyStreamController.sink.add(_historyList);
  }

  void addHistory(CalculationHistory value) {
    _historyList.add(value);
    _historyStreamController.sink.add(_historyList);
  }

  final _historyStreamController = StreamController<List<CalculationHistory>>();
  Stream<List<CalculationHistory>> get historyStream =>
      _historyStreamController.stream;

  String _calculationValueString = Strings.ZERO;
  String get calculationValue => _calculationValueString;
  set calculationValue(String value) {
    _calculationValueString = value;
    _calculationValueStreamController.sink.add(_calculationValueString);
  }

  final _calculationValueStreamController = StreamController<String>();
  Stream<String> get calculationValueStream =>
      _calculationValueStreamController.stream;

  final _snackStreamController = StreamController<SnackData>();
  Stream<SnackData> get snackStream => _snackStreamController.stream;

  CalculationType _calculationType;

  bool _isResultDisplayed = true;

  User user;

  IOWebSocketChannel channel;

  void connect(String name) async {
    channel = IOWebSocketChannel.connect("ws://192.168.0.101:8888/connect",
        headers: {"Authorization": "Bearer $name"});
    channel.stream.listen((event) {
      final map = json.decode(event) as Map<String, dynamic>;

      final isUser = map
          .containsKey("name"); //TODO прогуглить нормальный способ определения
      if (isUser) {
        user = User.fromJson(map);
        _stateStreamController.add(MainScreenCommonState());
        _areCalculationsButtonsEnabledStreamController.sink.add(true);
        print("user $event parsed");
      }

      final isCalculationResult = map.containsKey("calculationType");
      if (isCalculationResult) {
        final calculationResult = CalculationHistory.fromJson(map);
        _calculationValueStreamController.sink
            .add(calculationResult.result.toString());
        _isResultDisplayed = true;
        _areDigitsButtonsEnabledStreamController.sink.add(false);
        addHistory(calculationResult);
      }

      final isErrorMessage = map.containsKey("message");
      if (isErrorMessage) {
        ErrorMessage message = ErrorMessage.fromJson(map);
        _showSnack(message.message);
        _isResultDisplayed = true;
        _calculationValueStreamController.sink
            .add(_historyList.last.result.toString());
      }
      print(event);
    });
    channel.sink.add(json.encode(User.named(name).toJson()));
    print(channel);
  }

  void addDigit(String digit) {
    if (calculationValue.contains(Strings.DOT) && digit == Strings.DOT) {
      return;
    }
    if (_isResultDisplayed) {
      calculationValue =
          digit == Strings.DOT && (calculationValue.isEmpty || calculationValue == Strings.ZERO) ? "0." : digit;
      _isResultDisplayed = false;
    } else {
      if (calculationValue == Strings.ZERO) {
        calculationValue = digit;
      } else {
        calculationValue +=
            digit == Strings.DOT && (calculationValue.isEmpty || calculationValue == Strings.ZERO) ? "0." : digit;
      }
    }
  }

  void setCalculationType(CalculationType calculationType) {
    _calculationType = calculationType;
    _areDigitsButtonsEnabledStreamController.sink.add(true);
    if (_isResultDisplayed) {
      return;
    }
    calculate();
  }

  void calculate() {
    if (_calculationType == null) {
      return;
    }
    final calculationJson = CalculationRequest(
            user?.id ?? 0, _calculationType, double.parse(calculationValue))
        .toJson();
    final jsonValue = json.encode(calculationJson);
    print(jsonValue);
    channel.sink.add(jsonValue);
  }

  void _showSnack(String message) {
    _snackStreamController.sink.add(SnackData(message));
  }

  void removeLastDigit() {
    if (_isResultDisplayed) {
      return;
    }
    if (calculationValue.length <= 1) {
      calculationValue = Strings.ZERO;
    } else {
      calculationValue =
          calculationValue.substring(0, calculationValue.length - 1);
    }
  }

  void dispose() {
    _stateStreamController.close();
  }
}

class MainScreenState {}

class MainScreenCommonState extends MainScreenState {}

class MainScreenIntroState extends MainScreenState {}

class SnackData {
  String snackMessage;

  SnackData(this.snackMessage);
}
