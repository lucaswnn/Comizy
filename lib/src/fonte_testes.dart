import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:comizy/src/product.dart';

class TestData {
  LocationData? currentLocation;
  final List<LatLng> shopLatLng = [];
  final List<Product> products = [
    Product('Produto 1', 1, 'Tipo 1'),
    Product('Produto 2', 2, 'Tipo 2'),
    Product('Produto 3', 2, 'Tipo 2'),
    Product('Produto 4', 3, 'Tipo 3'),
    Product('Produto 5', 5, 'Tipo 4'),
    Product('Produto 6', 7, 'Tipo 1'),
    Product('Produto 7', 9, 'Tipo 1'),
    Product('Produto 8', 2, 'Tipo 5'),
    Product('Produto 9', 2, 'Tipo 2'),
    Product('Produto 10', 2, 'Tipo 3'),
  ];

  void loadLocations(LatLng? latlng) {
    if (latlng != null) {
      shopLatLng.add(LatLng(
        latlng.latitude + 0.01,
        latlng.longitude + 0.01,
      ));

      shopLatLng.add(LatLng(
        latlng.latitude + 0.02,
        latlng.longitude + 0.01,
      ));

      shopLatLng.add(LatLng(
        latlng.latitude + 0.02,
        latlng.longitude - 0.01,
      ));

      shopLatLng.add(LatLng(
        latlng.latitude - 0.01,
        latlng.longitude + 0.01,
      ));

      shopLatLng.add(LatLng(
        latlng.latitude - 0.02,
        latlng.longitude,
      ));
    } else {
      print('erro_comizy_fonte_testes');
    }
  }
}
