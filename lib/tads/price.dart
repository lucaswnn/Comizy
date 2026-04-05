class Price{
  final double value;
  final String unit;
  const Price({required this.value, required this.unit});

  @override
  String toString() => 'R\$${value.toStringAsFixed(2)} ($unit)';
}