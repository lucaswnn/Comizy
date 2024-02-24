import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyState(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "App",
        home: MyHome(),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('teste'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddWidget(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: const MyMap(),
    );
  }
}

class AddWidget extends StatelessWidget {
  const AddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          var state = Provider.of<MyState>(context, listen: false);
          state.addPoint();
          print(state.basicPoints.length);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  MapController controller = MapController();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  Marker createMarker(LatLng pos) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: pos,
      builder: (context) => const Icon(
        Icons.circle,
        size: 15,
        shadows: [
          Shadow(
            color: Colors.blueAccent,
            blurRadius: 6,
          )
        ],
        color: Colors.blue,
      ),
    );
  }

  void addMarker(LatLng pos) {
    setState(() {
      markers.add(createMarker(pos));
    });
  }

  void setFuture() async {
    var state = Provider.of<MyState>(context, listen: true);

    List<LatLng> points = state.basicPoints;
    for (var point in points) {
      addMarker(point);
    }
  }

  @override
  Widget build(BuildContext context) {
    setFuture();
    return FlutterMap(
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        maxZoom: 17.7,
        keepAlive: false,
        center: const LatLng(-21, -41),
        zoom: 13,
        onTap: (tapPosition, point) {
          print('tap');
          var state = Provider.of<MyState>(context, listen: false);
          state.addPoint();
          setState(() {});
          print(state.basicPoints.length);
        },
      ),
      mapController: controller,
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.comizy.comizy',
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}

class MyState extends ChangeNotifier {
  List<LatLng> basicPoints = [
    const LatLng(-20.99, -40.97),
    const LatLng(-20.991, -40.971),
  ];

  Future<List<LatLng>> points() {
    return Future.delayed(const Duration(seconds: 1), () => basicPoints);
  }

  void addPoint() {
    basicPoints.add(LatLng(
        basicPoints.last.latitude + 0.002, basicPoints.last.longitude + 0.002));
    notifyListeners();
  }
}
