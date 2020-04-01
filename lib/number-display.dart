import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NumberDisplay extends StatelessWidget {
  NumberDisplay({this.value: ''});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
          padding: EdgeInsets.all(20),
          child: AutoSizeText(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )),
    );
  }
}
