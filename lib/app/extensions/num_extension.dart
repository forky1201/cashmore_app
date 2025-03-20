import 'package:intl/intl.dart';

extension NumExtensions on num {
  String format({String format = '###,###.##'}) {
    return NumberFormat(format).format(this);
  }
}