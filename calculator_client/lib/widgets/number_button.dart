import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  NumberButton(this.text, this.onPressed);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.15,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w100
              ),
            ),
          ),
        ),
        color: Color(0xFF6979F8),
        splashColor: Color(0xFF9BA6FA),
        disabledColor: Color(0xFFCDD2FD),
      ),
    );
  }
}
