import 'package:calculator_server/calculator_server.dart';

class CalculationInteractor {
  CalculationInteractor();

  final _calculationRepository = CalculationRepository();
  final _userRepository = UserRepository();

  List<CalculationHistory> getCalculations() => _calculationRepository.get();

  CalculationHistory insertCalculation(CalculationRequest calculation) {
    User user;
    try {
      user = _userRepository.get().firstWhere((element) => element.id == calculation.userId);
    } catch(e) {
      return null;
    }
    final lastResult = _calculationRepository.get().isEmpty
        ? 0.0
        : _calculationRepository.get().last.result;
    final calculationHistory = CalculationHistory(calculation.calculationType, calculation.calculationValue, user, DateTime.now(), _calculate(calculation.calculationType, calculation.calculationValue, lastResult));
    _calculationRepository.insert(calculationHistory);
    return calculationHistory;
  }

  double _calculate(CalculationType type, double value, double lastResult) {
    var result = 0.0;
    switch (type) {
      case CalculationType.plus:
        result = lastResult + value;
        break;
      case CalculationType.minus:
        result = lastResult - value;
        break;
      case CalculationType.multiply:
        result = lastResult * value;
        break;
      case CalculationType.divide:
        result = lastResult / value;
        break;
      case CalculationType.pow:
        result = pow(lastResult, value).toDouble();
        break;
      case CalculationType.zero:
        result = 0.0;
        break;
    }
    return result;
  }
}
