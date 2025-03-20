import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String format({String format = 'yyyy.MM.dd'}) {
    return DateFormat(format).format(this);
  }
}