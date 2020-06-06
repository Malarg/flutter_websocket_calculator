import 'package:calculator_server/calculator_server.dart';

class CalculationRepository {
  factory CalculationRepository() {
    return _singleton;
  }

  CalculationRepository._internal();

  static final _singleton = CalculationRepository._internal();

  static final _calculations = <CalculationHistory>[CalculationHistory(CalculationType.zero, 0, User(0, ""), DateTime.now(), 0)];

  List<CalculationHistory> get() => _calculations;

  CalculationHistory insert(CalculationHistory calculation) {
    _calculations.add(calculation);
    return calculation;
  }
}
