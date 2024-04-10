String mySqlDateConversion(String rawDate) {
  final values = rawDate.split('-');
  return '${values.last}/${values[1]}/${values.first}';
}
