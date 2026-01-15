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
  final pageController = PageController();

  final List<Widget> pages = const [
    HomePage(),
    ShowcasePage(),
    HelpRequestPage(),
    UserPage(),
  ];

  final List<NavigationDestination> navItems = const [
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

  int currentNavIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: currentNavIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                NavigationHelper.pushNamed(AppRoutes.leaderboardPage);
              },
              child: const Icon(Icons.leaderboard),
            )
          : null,
      body: PageView(
        controller: pageController,
        onPageChanged: (i) => setState(() => currentNavIndex = i),
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: navItems,
        selectedIndex: currentNavIndex,
        onDestinationSelected: (index) => setState(
          () {
            currentNavIndex = index;
            pageController.animateToPage(
              currentNavIndex,
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
