import 'package:logger/logger.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super(printer: PrettyPrinter(printTime: true));
  static final instance = Log._();
}
// Logger getLogger([String? className]) {
//   return Logger(
//     printer: PrettyPrinter(),
//     level: Level.info
//   );
// }