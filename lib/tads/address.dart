class Address {
  final String street;
  final String neighborhood;
  final String city;

  const Address({
    required this.street,
    required this.neighborhood,
    required this.city,
  });

  static const nullAddress = Address(street: '', neighborhood: '', city: '');
}