import 'package:intl/intl.dart';

class DateTimeHelper {
  const DateTimeHelper._();

  static String formatDate(DateTime dateTime, [String? locale]) {
    final formatter = DateFormat('MMMM d, yyyy', locale);
    return formatter.format(dateTime);
  }
}