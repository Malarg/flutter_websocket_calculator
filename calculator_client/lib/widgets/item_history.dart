import 'package:calculation_core/calculation_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculationHistoryWidget extends StatelessWidget {
  CalculationHistoryWidget(this._calculationHistory);

  final CalculationHistory _calculationHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(_calculationHistory.user.name +
              " — " +
              DateFormat("HH:mm:ss").format(_calculationHistory.timestamp)),
          Text(getCalculationString())
        ],
      ),
    );
  }

  String getCalculationString() {
    String calculationString;
    switch (_calculationHistory.calculationType) {
      case CalculationType.plus:
        {
          calculationString = "+ ";
        }
        break;
      case CalculationType.minus:
        {
          calculationString = "- ";
        }
        break;
      case CalculationType.multiply:
        {
          calculationString = "* ";
        }
        break;
      case CalculationType.divide:
        {
          calculationString = "/ ";
        }
        break;
      case CalculationType.pow:
        {
          calculationString = "^ ";
        }
        break;
      case CalculationType.zero:
        {
          calculationString = "C";
        }
        break;
    }
    if (_calculationHistory.calculationType != CalculationType.zero) {
      calculationString += _calculationHistory.value.toString() +
          " = " +
          _calculationHistory.result.toString();
    }
    return calculationString;
  }
}
