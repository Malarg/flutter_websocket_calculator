import 'dart:async';

import 'package:calculation_core/calculation_core.dart';

class MainBloc {
  final _stateStreamController = StreamController<MainScreenState>();

  Stream<MainScreenState> get state => _stateStreamController.stream;

  var data = MainScreenDataState();

  void addDigit(String digit) {
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