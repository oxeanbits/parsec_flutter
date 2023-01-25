# parsec

A Flutter plugin for calculating math equations using C++ library.

## Usage

To use this plugin, add `parsec` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

```dart
import 'package:parsec/parsec.dart';

void main() {
    final Parsec _parsecPlugin = Parsec();
    String equation = '5*5 + 5!';
    String _parsecResult = '';

    try {
        _parsecResult = await _parsecPlugin.nativeEval(equation) ??
            'Invalid equation';
    } catch (e) {
        log(e.toString());
        _parsecResult = 'Failed to eval equation';
    }
}
```

### Here are examples of equations which are accepted by the parsec
```dart
final Parsec parsec = Parsec();

# Simple Math equations
parsec.nativeEval('(5 + 1) + (6 - 2)')  # result => 10
parsec.nativeEval('4 + 4 * 3')          # result => 16
parsec.nativeEval('10.5 / 5.25')        # result => 2
parsec.nativeEval('abs(-5)')            # result => 5
parsec.nativeEval('sqrt(16) + cbrt(8)') # result => 6
parsec.nativeEval('log10(10)')          # result => 1
parsec.nativeEval('round(4.4)')         # result => 4
parsec.nativeEval('(3^3)^2')            # result => 729
parsec.nativeEval('3^(3^(2))')          # result => 19683
parsec.nativeEval('10!')                # result => 3628800
parsec.nativeEval('string(10)')         # result => "10"

# Complex Math equations
parsec.nativeEval('log10(10) + ln(e) + log(10)')       # result => 4.30259
parsec.nativeEval('sin(1) + cos(0) + tan(0.15722)')    # result => 2.0
parsec.nativeEval('max(1, 2) + min(3, 4) + sum(5, 6)') # result => 16
parsec.nativeEval('avg(9, 9.8, 10)')                   # result => 9.6
parsec.nativeEval('pow(2, 3)')                         # result => 8
parsec.nativeEval('round_decimal(4.559, 2)')           # result => 4.56

# IF THEN ELSE equations
parsec.nativeEval('4 > 2 ? "bigger" : "smaller"')    # result => "bigger"
parsec.nativeEval('2 == 2 ? true : false')           # result => true
parsec.nativeEval('2 != 2 ? true : false')           # result => false
parsec.nativeEval('"this" == "this" ? "yes" : "no"') # result => "yes"
parsec.nativeEval('"this" != "that" ? "yes" : "no"') # result => "yes"

# Logic equations
parsec.nativeEval('true and false')    # result => false
parsec.nativeEval('true or false')     # result => true
parsec.nativeEval('(3==3) and (3!=3)') # result => false
parsec.nativeEval('exp(1) == e')       # result => true

# String equations
parsec.nativeEval('length("test string")')     # result => 11
parsec.nativeEval('toupper("test string")')    # result => "TEST STRING"
parsec.nativeEval('tolower("TEST STRING")')    # result => "test string"
parsec.nativeEval('concat("Hello ", "World")') # result => "Hello World"
parsec.nativeEval('link("Title", "http://foo.bar")') # result => "<a href="http://foo.bar">Title</a>"
parsec.nativeEval('str2number("5")')           # result => 5
parsec.nativeEval('left("Hello World", 5)')    # result => "Hello"
parsec.nativeEval('right("Hello World", 5)')   # result => "World"
parsec.nativeEval('number("5")')               # result => 5

# Date equations (return the difference in days)
parsec.nativeEval("current_date()"))                        # result => "2018-10-03"
parsec.nativeEval('daysdiff(current_date(), "2018-10-04")') # result => 1
parsec.nativeEval('daysdiff("2018-01-01", "2018-12-31")')   # result => 364

# DateTime equations (return the difference in hours)
parsec.nativeEval('hoursdiff("2018-01-01", "2018-01-02")')             # result => 24
parsec.nativeEval('hoursdiff("2019-02-01T08:00", "2019-02-01T12:00")') # result => 4
parsec.nativeEval('hoursdiff("2019-02-01T08:20", "2019-02-01T12:00")') # result => 3.67
parsec.nativeEval('hoursdiff("2018-01-01", "2018-01-01")')             # result => 0
```

### The following functions can be used

* Math trigonometric functions: **sin**, **cos**, **tan**, **sinh**, **cosh**, **tanh**, **asin**, **acos**, **atan**, **asinh**, **acosh**, **atanh**
* Math logarithm functions: **ln**, **log**, **log10**
* Math standard functions: **abs**, **sqrt**, **cbrt**, **pow**, **exp**, **round**, **round_decimal**
* Number functions: **string**
* Math constants: **e**, **pi**
* Unlimited number of arguments: **min**, **max**, **sum**, **avg**
* String functions: **concat**, **length**, **toupper**, **tolower**, **left**, **right**, **str2number**, **number**, **link**
* Complex functions: **real**, **imag**, **conj**, **arg**, **norm**
* Array functions: **sizeof**, **eye**, **ones**, **zeros**
* Date functions: **current_date**, **daysdiff**, **hoursdiff**
* Extra functions: **default_value**
