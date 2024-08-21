import 'package:intl/intl.dart';

String mySqlDateConversion(String rawDate) {
  final values = rawDate.split('-');
  return '${values.last}/${values[1]}/${values.first}';
}

String realFormattedValue(double value) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');
    return curFormat.format(value);
  }