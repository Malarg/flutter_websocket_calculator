// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculationHistory _$CalculationHistoryFromJson(Map<String, dynamic> json) {
  return CalculationHistory(
    _$enumDecodeNullable(_$CalculationTypeEnumMap, json['calculationType']),
    (json['value'] as num)?.toDouble(),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    (json['result'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CalculationHistoryToJson(CalculationHistory instance) =>
    <String, dynamic>{
      'calculationType': _$CalculationTypeEnumMap[instance.calculationType],
      'value': instance.value,
      'user': instance.user,
      'timestamp': instance.timestamp?.toIso8601String(),
      'result': instance.result,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$CalculationTypeEnumMap = {
  CalculationType.plus: 'plus',
  CalculationType.minus: 'minus',
  CalculationType.multiply: 'multiply',
  CalculationType.divide: 'divide',
  CalculationType.pow: 'pow',
  CalculationType.zero: 'zero',
};

CalculationRequest _$CalculationRequestFromJson(Map<String, dynamic> json) {
  return CalculationRequest(
    json['userId'] as int,
    _$enumDecodeNullable(_$CalculationTypeEnumMap, json['calculationType']),
    (json['calculationValue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CalculationRequestToJson(CalculationRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'calculationType': _$CalculationTypeEnumMap[instance.calculationType],
      'calculationValue': instance.calculationValue,
    };
