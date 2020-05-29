import 'package:calculation_core/calculation_core.dart';

part 'calculation.g.dart';

@JsonSerializable()
class Calculation {
  Calculation(this.calculationType, this.value, this.user, this.timestamp,
      {this.result});

  factory Calculation.fromJson(Map<String, dynamic> json) =>
      _$CalculationFromJson(json);
  Map<String, dynamic> toJson() => _$CalculationToJson(this);

  CalculationType calculationType;
  double value;
  User user;
  DateTime timestamp;
  double result;
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
