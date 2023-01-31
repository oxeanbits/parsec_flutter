# parsec [![package publisher](https://img.shields.io/pub/publisher/parsec_platform_interface.svg)](https://pub.dev/packages/parsec_platform_interface/publisher) [![pub package](https://img.shields.io/pub/v/parsec_platform_interface.svg)](https://pub.dev/packages/parsec_platform_interface)

The multi-platform `parsec` plugin for Flutter to calculate math equations using C++ library.

## Platform Support

| Android | iOS | Windows | Linux | MacOS | Web |
| :-----: | :-: | :-----: | :---: | :---: | :-: |
|   ✔️    | ❌️ |   ❌️   |  ✔️  |  ❌️  | ❌️ |

## Usage

To use this plugin, add `parsec` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

```dart
import 'package:parsec/parsec.dart';

void main() {
    final Parsec parsec = Parsec();
    dynamic result;

    try {
        result = await parsec.eval('5*5 + 5!');
    } catch (e) {
        result = e.toString();
    }
}
```

### Here are examples of equations which are accepted by the parsec

```dart
final Parsec parsec = Parsec();

# Simple Math equations
parsec.eval('(5 + 1) + (6 - 2)')  # result => 10
parsec.eval('4 + 4 * 3')          # result => 16
parsec.eval('10.5 / 5.25')        # result => 2
parsec.eval('abs(-5)')            # result => 5
parsec.eval('sqrt(16) + cbrt(8)') # result => 6
parsec.eval('log10(10)')          # result => 1
parsec.eval('round(4.4)')         # result => 4
parsec.eval('(3^3)^2')            # result => 729
parsec.eval('3^(3^(2))')          # result => 19683
parsec.eval('10!')                # result => 3628800
parsec.eval('string(10)')         # result => "10"

# Complex Math equations
parsec.eval('log10(10) + ln(e) + log(10)')       # result => 4.30259
parsec.eval('sin(1) + cos(0) + tan(0.15722)')    # result => 2.0
parsec.eval('max(1, 2) + min(3, 4) + sum(5, 6)') # result => 16
parsec.eval('avg(9, 9.8, 10)')                   # result => 9.6
parsec.eval('pow(2, 3)')                         # result => 8
parsec.eval('round_decimal(4.559, 2)')           # result => 4.56

# IF THEN ELSE equations
parsec.eval('4 > 2 ? "bigger" : "smaller"')    # result => "bigger"
parsec.eval('2 == 2 ? true : false')           # result => true
parsec.eval('2 != 2 ? true : false')           # result => false
parsec.eval('"this" == "this" ? "yes" : "no"') # result => "yes"
parsec.eval('"this" != "that" ? "yes" : "no"') # result => "yes"

# Logic equations
parsec.eval('true and false')    # result => false
parsec.eval('true or false')     # result => true
parsec.eval('(3==3) and (3!=3)') # result => false
parsec.eval('exp(1) == e')       # result => true

# String equations
parsec.eval('length("test string")')     # result => 11
parsec.eval('toupper("test string")')    # result => "TEST STRING"
parsec.eval('tolower("TEST STRING")')    # result => "test string"
parsec.eval('concat("Hello ", "World")') # result => "Hello World"
parsec.eval('link("Title", "http://foo.bar")') # result => "<a href="http://foo.bar">Title</a>"
parsec.eval('str2number("5")')           # result => 5
parsec.eval('left("Hello World", 5)')    # result => "Hello"
parsec.eval('right("Hello World", 5)')   # result => "World"
parsec.eval('number("5")')               # result => 5

# Date equations (return the difference in days)
parsec.eval("current_date()"))                        # result => "2018-10-03"
parsec.eval('daysdiff(current_date(), "2018-10-04")') # result => 1
parsec.eval('daysdiff("2018-01-01", "2018-12-31")')   # result => 364

# DateTime equations (return the difference in hours)
parsec.eval('hoursdiff("2018-01-01", "2018-01-02")')             # result => 24
parsec.eval('hoursdiff("2019-02-01T08:00", "2019-02-01T12:00")') # result => 4
parsec.eval('hoursdiff("2019-02-01T08:20", "2019-02-01T12:00")') # result => 3.67
parsec.eval('hoursdiff("2018-01-01", "2018-01-01")')             # result => 0
```

### The following functions can be used

- Math trigonometric functions: **sin**, **cos**, **tan**, **sinh**, **cosh**, **tanh**, **asin**, **acos**, **atan**, **asinh**, **acosh**, **atanh**
- Math logarithm functions: **ln**, **log**, **log10**
- Math standard functions: **abs**, **sqrt**, **cbrt**, **pow**, **exp**, **round**, **round_decimal**
- Number functions: **string**
- Math constants: **e**, **pi**
- Unlimited number of arguments: **min**, **max**, **sum**, **avg**
- String functions: **concat**, **length**, **toupper**, **tolower**, **left**, **right**, **str2number**, **number**, **link**
- Complex functions: **real**, **imag**, **conj**, **arg**, **norm**
- Array functions: **sizeof**, **eye**, **ones**, **zeros**
- Date functions: **current_date**, **daysdiff**, **hoursdiff**
- Extra functions: **default_value**
