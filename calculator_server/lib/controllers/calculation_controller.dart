import 'package:calculator_server/calculator_server.dart';

class CalculationController extends ResourceController {
  CalculationController();

  final _calculationRepository = CalculationRepository();
  final _userRepository = UserRepository();

  @Operation.get()
  Future<Response> getCalculations() async {
    return Response.ok(_calculationRepository.get().map((e) => e.toJson()));
  }

  @Operation.post()
  Future<Response> insertCalculation(Calculation calculation) async {
    final lastResult = _calculationRepository.get().isEmpty
        ? 0.0
        : _calculationRepository.get().last.result;
    _calculationRepository.insert(calculation);
    final isUserExist = _userRepository.get().map((e) => e.id).contains(calculation.user.id);
    if (isUserExist) {
      return Response.ok(_calculate(calculation.calculationType, calculation.value,
        lastResult));
    } else {
      return Response.unauthorized();
    }
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
