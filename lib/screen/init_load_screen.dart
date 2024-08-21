import 'package:comizy/state/geo_state.dart';
import 'package:comizy/state/market_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitLoadScreen extends StatelessWidget {
  const InitLoadScreen({super.key});

  // widget aguardando carregamento de dados
  Material _loadingScreen() {
    return const Material(
      key: ValueKey<int>(0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Carregando localização e dados...'),
            SizedBox(height: 10),
            Text(
                'Precisamos de sua localização para detectar o mercado ao seu redor'),
          ],
        ),
      ),
    );
  }

  // widget para requisição de permissão de localização
  Material _showRequestScreen(GeoState geoState) {
    return Material(
      key: const ValueKey<int>(1),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Autorize a localização de seu dispositivo para poder utilizar o aplicativo',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 15),
              IconButton(
                onPressed: () {
                  geoState.reloadLocation();
                },
                icon: const Icon(
                  Icons.location_on,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // widget gerado após processamento de localização e mercado
  Material _loadedScreen(String message) {
    return Material(
      key: const ValueKey<int>(2),
      child: Center(
        child: Text(message),
      ),
    );
  }

  // método para criar rota para a homepage após o build de InitLoadScreen
  void _launchHomeScreen(BuildContext context, int transitionTime) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: transitionTime + 1))
          .then((value) => Navigator.of(context).pushNamed('/home'));
    });
  }

  @override
  Widget build(BuildContext context) {
    Material returnedWidget;
    const transitionTime = 1;

    // carregar localização
    final geoState = context.watch<GeoState>();
    geoState.loadLocation();

    // aguardando permissão para acessar localização
    if (geoState.isLocationLoaded == null) {
      returnedWidget = _loadingScreen();

      // mensagem caso permissão seja negada
    } else if (!geoState.isLocationLoaded!) {
      returnedWidget = _showRequestScreen(geoState);

      // após localização, carregamento do mercado
    } else {
      final marketState = context.watch<MarketState>();
      marketState.loadMarket();

      // aguardando mercado ser carregado
      if (marketState.isMarketLoaded == null) {
        returnedWidget = _loadingScreen();

        // erro de carregamento ou mercado inexistente no local
      } else if (!marketState.isMarketLoaded!) {
        returnedWidget =
            _loadedScreen('Não foi possível carregar o mercado em seu local');
        _launchHomeScreen(context, transitionTime);

        // carregamento completo e bem sucedido
      } else {
        returnedWidget = _loadedScreen('Dados carregados com sucesso');
        _launchHomeScreen(context, transitionTime);
      }
    }

    return AnimatedSwitcher(
        duration: const Duration(seconds: transitionTime),
        child: returnedWidget);
  }
}
