import 'package:calculator_server/calculator_server.dart';

class CalculationRepository {
  factory CalculationRepository() {
    return _singleton;
  }

  CalculationRepository._internal();

  static final _singleton = CalculationRepository._internal();

  static final _calculations = <Calculation>[];

  List<Calculation> get() => _calculations;

  Calculation insert(Calculation calculation) {
    _calculations.add(calculation);
    return calculation;
  }
}
