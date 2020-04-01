import 'package:flutter/material.dart';
import 'calculator.dart';
import 'number-display.dart';
import 'calculator-buttons.dart';
import 'history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isNewEquation = true;
  List<double> values = [];
  List<String> operations = [];
  List<String> calculations = [];
  String calculatorString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                _navigateAndDisplayHistory(context);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            NumberDisplay(value: calculatorString),
            CalculatorButtons(onTap: _onPressed),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }

  _navigateAndDisplayHistory(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => History(operations: calculations)));

    if (result != null) {
      setState(() {
        isNewEquation = false;
        calculatorString = Calculator.parseString(result);
      });
    }
  }

  void _onPressed({String buttonText}) {
    // Standard mathematical operations
    if (Calculations.OPERATIONS.contains(buttonText)) {
      return setState(() {
        operations.add(buttonText);
        calculatorString += " $buttonText ";
      });
    }

    // On CLEAR press
    if (buttonText == Calculations.CLEAR) {
      return setState(() {
        operations = [];
        calculatorString = '';
      });
    }

    // On Equals press
    if (buttonText == Calculations.EQUAL) {
      String newCalculatorString = Calculator.parseString(calculatorString);

      return setState(() {
        if (newCalculatorString != calculatorString) {
          // only add evaluated strings to calculations array
          calculations.add(calculatorString);
        }

        operations.add(Calculations.EQUAL);
        calculatorString = newCalculatorString;
        isNewEquation = false;
      });
    }

    // On identifier press
    if (Calculations.IDENTIFIERS.contains(buttonText)) {
      if (operations.isNotEmpty) {
        List<String> s = calculatorString.split(operations.last);
        if (!s[1].contains(buttonText)) {
          return setState(() {
            calculatorString += "$buttonText ";
          });
        } else
          return;
      } else {
        if (calculatorString.isEmpty ||
            int.tryParse(
                    calculatorString.substring(calculatorString.length - 1)) ==
                null) {
          return setState(() {
            calculatorString += "00$buttonText ";
          });
        }
        if (!calculatorString.contains(buttonText)) {
          return setState(() {
            calculatorString += "$buttonText ";
          });
        } else {
          return;
        }
      }
    }

/*     if (buttonText == Calculations.PERIOD) {
      return setState(() {
        calculatorString = Calculator.addPeriod(calculatorString);
      });
    } */

    if (buttonText == 'DEL') {
      return setState(() {
        calculatorString = calculatorString.substring(
            0,
            calculatorString.endsWith(' ')
                ? Calculations.IDENTIFIERS
                        .contains(calculatorString[calculatorString.length - 2])
                    ? calculatorString.length - 2
                    : calculatorString.length - 3
                : calculatorString.length - 1);
      });
    }

    setState(() {
      if (!isNewEquation &&
          operations.length > 0 &&
          operations.last == Calculations.EQUAL) {
        calculatorString = buttonText;
        isNewEquation = true;
        operations = List();
      } else {
        calculatorString += buttonText;
      }
    });
  }
}
