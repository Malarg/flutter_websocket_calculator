import 'dart:async';

import 'dart:convert';

import 'package:calculation_core/calculation_core.dart';

import 'package:web_socket_channel/io.dart';

class MainBloc {
  final _stateStreamController = StreamController<MainScreenState>();

  Stream<MainScreenState> get state => _stateStreamController.stream;
  IOWebSocketChannel channel;

  var data = MainScreenDataState();

  void connect(String name) async {
    channel = IOWebSocketChannel.connect("ws://192.168.0.102:8888/connect", headers: {"Authorization": "Bearer $name"});
    channel.stream.listen((event) {
      print(event);
    });
    _stateStreamController.add(MainScreenDataState());
    print(channel);
  }

  void addDigit(String digit) {
    channel.sink.add(json.encode(User.named(digit).toJson()));
    if (data.calculationValue.contains(".") && digit == ".") {
      return;
    }
    if (data.isResultDisplayed) {
      data.calculationValue = digit == "." && data.calculationValue.isEmpty ? "0." : digit;
      data.isResultDisplayed = false;
    } else {
      data.calculationValue += digit == "." && data.calculationValue.isEmpty ? "0." : digit;
    }
    _stateStreamController.sink.add(data);
  }

  void setCalculationType(CalculationType calculationType) {
    data.calculationType = calculationType;
  }

  void removeLastDigit() {
    if (data.calculationValue.length <= 1) {
      data.calculationValue = "0";
    } else {
      data.calculationValue = data.calculationValue.substring(0, data.calculationValue.length - 1);
    }
    _stateStreamController.sink.add(data);
  }

  void calculate() {

  }

  void dispose() {
    _stateStreamController.close();
  }
}

class MainScreenState {
  
}

class MainScreenDataState extends MainScreenState {
  User user;
  CalculationType calculationType;
  String calculationValue = "";
  bool isResultDisplayed = false;
}

class MainScreenIntroState extends MainScreenState {

}

class MainScreenErrorState extends MainScreenState {

}