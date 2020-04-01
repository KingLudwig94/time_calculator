import 'number-formatter.dart';

class Calculations {
  static const PERIOD = '.';
  static const MULTIPLY = '*';
  static const SUBTRACT = '-';
  static const ADD = '+';
  static const DIVIDE = '/';
  static const CLEAR = 'CLEAR';
  static const EQUAL = '=';
  static const OPERATIONS = [
    Calculations.ADD,
    Calculations.MULTIPLY,
    Calculations.SUBTRACT,
    Calculations.DIVIDE,
  ];
  static const IDENTIFIERS = [
    'h',
    'm',
    'd',
  ];

  static Duration add(Duration a, Duration b) => a + b;
  static Duration subtract(Duration a, Duration b) => a - b;
  static Duration divide(Duration a, double b) {
    int r = a.inMinutes ~/ b;
    int d = r ~/ (60 * 24);
    r -= d * (60 * 24);
    int h = r ~/ 60;
    r -= h * 60;
    return Duration(days: d, hours: h, minutes: r);
  }

  static Duration multiply(Duration a, double b) => a * b;
}

class Calculator {
  static String parseString(String text) {
    List<String> numbersToAdd;
    Duration a, b, result;
    if (text.contains(Calculations.ADD)) {
      numbersToAdd = text.split(Calculations.ADD);
      a = stringToDuration(numbersToAdd[0]);
      b = stringToDuration(numbersToAdd[1]);

      result = Calculations.add(a, b);
    } else if (text.contains(Calculations.MULTIPLY)) {
      numbersToAdd = text.split(Calculations.MULTIPLY);
      a = stringToDuration(numbersToAdd[0]);
      double c = double.parse(numbersToAdd[1]);

      result = Calculations.multiply(a, c);
    } else if (text.contains(Calculations.DIVIDE)) {
      numbersToAdd = text.split(Calculations.DIVIDE);
      a = stringToDuration(numbersToAdd[0]);
      double c = double.parse(numbersToAdd[1]);

      result = Calculations.divide(a, c);
    } else if (text.contains(Calculations.SUBTRACT)) {
      numbersToAdd = text.split(Calculations.SUBTRACT);
      a = stringToDuration(numbersToAdd[0]);
      b = stringToDuration(numbersToAdd[1]);

      result = Calculations.subtract(a, b);
    } else {
      return text;
    }

    return NumberFormatter.format(result);
  }

  static String addPeriod(String calculatorString) {
    if (calculatorString.isEmpty) {
      return calculatorString = '0${Calculations.PERIOD}';
    }

    RegExp exp = new RegExp(r"\d\.");
    Iterable<Match> matches = exp.allMatches(calculatorString);
    int maxMatches = Calculator.includesOperation(calculatorString) ? 2 : 1;

    return matches.length == maxMatches
        ? calculatorString
        : calculatorString += Calculations.PERIOD;
  }

  static bool includesOperation(String calculatorString) {
    for (var operation in Calculations.OPERATIONS) {
      if (calculatorString.contains(operation)) {
        return true;
      }
    }

    return false;
  }

  static Duration stringToDuration(String string) {
    List<String> s = string.split(' ');
    int d = 0, h = 0, m = 0;
    s.forEach(
      (f) {
        if (f.contains('m')) {
          m = int.parse(f.substring(0, f.length - 1));
        } else if (f.contains('d')) {
          d = int.parse(f.substring(0, f.length - 1));
        } else if (f.contains('h')) {
          h = int.parse(f.substring(0, f.length - 1));
        }
      },
    );

    return Duration(days: d, hours: h, minutes: m);
  }
}
