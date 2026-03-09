import 'package:intl/intl.dart';

class DateTimeHelper {
  const DateTimeHelper._();

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(dateTime);
  }
}