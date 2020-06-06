import 'package:calculation_core/calculation_core.dart';

part 'error_message.g.dart';

@JsonSerializable()
class ErrorMessage {
  ErrorMessage(this.message);
  
  String message;

  static ErrorMessage fromJson(Map<String, dynamic> data) => _$ErrorMessageFromJson(data);
  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);
}