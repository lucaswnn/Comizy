import 'package:comizy/pages/connection_error_page.dart';
import 'package:comizy/pages/help_request_section/help_request_page.dart';
import 'package:comizy/pages/home_section/home_page.dart';
import 'package:comizy/pages/showcase_section/showcase_page.dart';
import 'package:comizy/pages/user_section/user_page.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final userNotifier = context.read<MainUserNotifier>();
    final locationNotifier = context.read<LocationNotifier>();
    final marketNotifier = context.read<MarketNotifier>();
    return FutureBuilder(
      future: Future.wait([
        userNotifier.loadData(forceReload: false),
        locationNotifier.loadData(forceReload: false),
        marketNotifier.loadData(forceReload: false),
      ]),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const ConnectionErrorPage();
        }
        return const _MainPageView();
      },
    );
  }
}

class _MainPageView extends StatefulWidget {
  const _MainPageView();

  @override
  State<_MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<_MainPageView> {
  final _pageController = PageController();

  final List<Widget> _pages = const [
    HomePage(),
    ShowcasePage(),
    HelpRequestPage(),
    UserPage(),
  ];

  final List<NavigationDestination> _navItems = const [
    NavigationDestination(
        icon: Icon(
          Icons.abc,
        ),
        label: 'Home'),
    NavigationDestination(
        icon: Icon(
          Icons.abc,
        ),
        label: 'Showcase'),
    NavigationDestination(
        icon: Icon(
          Icons.abc,
        ),
        label: 'Help'),
    NavigationDestination(
        icon: Icon(
          Icons.abc,
        ),
        label: 'User'),
  ];

  int _currentNavIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentNavIndex = i),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: _navItems,
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) => setState(
          () {
            _currentNavIndex = index;
            _pageController.animateToPage(
              _currentNavIndex,
              duration: Durations.medium1,
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.watch<LocationNotifier>();
    String locHint;
    if (locationNotifier.settedLocation == null) {
      locHint = 'Selecione\nsua localização';
    } else if (locationNotifier.isCurrentLocation) {
      locHint = 'Localização\natual';
    } else {
      locHint = 'Localização\npersonalizada';
    }

    return AppBar(
      leading: IconButton(
        onPressed: () => NavigationHelper.pushNamed(AppRoutes.userPersonalPage),
        icon: const Icon(Icons.person),
      ),
      actions: [
        Row(
          children: [
            Text(locHint),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () async {
                final shouldShowDialog =
                    await AppPreferences.shouldShowLocationMessage();
                if (!context.mounted) return;

                if (shouldShowDialog) {
                  showDialog(
                      context: context,
                      builder: (_) => const LocationAlertDialog());
                } else {
                  locationNotifier.askForGPS();
                  NavigationHelper.pushNamed(AppRoutes.setLocationPage);
                }
              },
              icon: const Icon(Icons.location_pin),
            ),
          ],
        )
      ],
    );
  }
}

class LocationAlertDialog extends StatefulWidget {
  const LocationAlertDialog({super.key});

  @override
  State<LocationAlertDialog> createState() => _LocationAlertDialogState();
}

class _LocationAlertDialogState extends State<LocationAlertDialog> {
  bool doNotShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uso de localização'),
      content: Column(
        children: [
          const Text('Para melhorar sua experiência, utilizamos o GPS '
              'para encontrar sua localização atual. '
              'O uso da localização não é obrigatório.'),
          const SizedBox(height: 10),
          Checkbox(
            value: doNotShowAgain,
            onChanged: (v) => setState(() => doNotShowAgain = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Continuar'),
          onPressed: () {
            if (doNotShowAgain) {
              AppPreferences.setShowLocationMessage(false);
            }
            NavigationHelper.pop();
            context.read<LocationNotifier>().askForGPS();
            NavigationHelper.pushNamed(AppRoutes.setLocationPage);
          },
        ),
      ],
    );
  }
}
