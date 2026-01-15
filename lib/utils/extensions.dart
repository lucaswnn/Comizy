extension DateTimeExtensions on DateTime {
  String get toShortDateString {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }
}
