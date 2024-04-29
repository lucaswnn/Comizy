import 'package:comizy/src/screen/home.dart';
import 'package:comizy/src/util/geo_util.dart';
import 'package:flutter/material.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool? _isGPSUsable;

  @override
  void initState() {
    _checkLocationIsReady();
    super.initState();
  }

  Future<void> _checkLocationIsReady() async {
    final isGPSPermitted = await checkGPSPermission();
    final isGPSEnabled = await checkGPSEnabled();

    if (isGPSPermitted && isGPSEnabled) {
      if (_isGPSUsable == null) {
        setState(() {
          _isGPSUsable = true;
        });
      } else if (!_isGPSUsable!) {
        setState(() {
          _isGPSUsable = true;
        });
      }
    } else {
      if (_isGPSUsable == null) {
        setState(() {
          _isGPSUsable = false;
        });
      } else if (_isGPSUsable!) {
        setState(() {
          _isGPSUsable = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String waitingMessage =
        'Autorize a localização de seu dispositivo para poder utilizar o aplicativo';

    if (_isGPSUsable == null) {
      return _showLoadingScreen();
    } else if (!_isGPSUsable!) {
      return _showRequestScreen(waitingMessage);
    }
    return const MyHome();
  }

  Center _showLoadingScreen() {
    return const Center(child: CircularProgressIndicator());
  }

  Material _showRequestScreen(String message) {
    return Material(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 15),
              IconButton(
                  onPressed: () {
                    _checkLocationIsReady();
                  },
                  icon: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 0, 66, 180),
                    size: 35,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
