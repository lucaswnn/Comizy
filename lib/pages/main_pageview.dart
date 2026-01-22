import 'package:comizy/pages/help_request_section/help_request_page.dart';
import 'package:comizy/pages/home_section/home_page.dart';
import 'package:comizy/pages/showcase_section/showcase_page.dart';
import 'package:comizy/pages/user_section/user_page.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
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
      floatingActionButton: _currentNavIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                NavigationHelper.pushNamed(AppRoutes.leaderboardPage);
              },
              child: const Icon(Icons.leaderboard),
            )
          : null,
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
      leading: const Icon(Icons.abc),
      actions: [
        Row(
          children: [
            Text(locHint),
            const SizedBox(width: 5),
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) => _alertDialogGPS(locationNotifier),
                  );
                },
                icon: const Icon(Icons.location_pin))
          ],
        )
      ],
    );
  }

  AlertDialog _alertDialogGPS(LocationNotifier locationNotifier) {
    return AlertDialog(
      title: const Text('Uso de localização'),
      content: const Text('Para melhorar sua experiência, utilizamos o GPS '
          'para encontrar sua localização atual. '
          'O uso da localização não é obrigatório.'),
      actions: [
        TextButton(
          child: const Text('Continuar'),
          onPressed: () async {
            NavigationHelper.pop();
            await locationNotifier.askForGPS();
            NavigationHelper.pushNamed(AppRoutes.setLocationPage);
          },
        ),
      ],
    );
  }
}
