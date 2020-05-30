import 'package:calculation_core/calculation_core.dart';

part 'calculation.g.dart';

@JsonSerializable()
class CalculationHistory {
  CalculationHistory(this.calculationType, this.value, this.user, this.timestamp, this.result);

  factory CalculationHistory.fromJson(Map<String, dynamic> json) =>
      _$CalculationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$CalculationHistoryToJson(this);

  CalculationType calculationType;
  double value;
  User user;
  DateTime timestamp;
  double result;
}

@JsonSerializable()
class CalculationRequest {

  CalculationRequest(this.userId, this.calculationType, this.calculationValue);

  factory CalculationRequest.fromJson(Map<String, dynamic> json) => _$CalculationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CalculationRequestToJson(this);

  int userId;
  CalculationType calculationType;
  double calculationValue;
}

enum CalculationType {
  @JsonValue("plus")
  plus,
  @JsonValue("minus")
  minus,
  @JsonValue("multiply")
  multiply,
  @JsonValue("divide")
  divide,
  @JsonValue("pow")
  pow,
  @JsonValue("zero")
  zero
}
