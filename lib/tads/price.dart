class Price{
  final double value;
  const Price(this.value);

  @override
  String toString() => 'R\$${value.toStringAsFixed(2)}';
}