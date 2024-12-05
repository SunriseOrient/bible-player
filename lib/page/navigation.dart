import 'package:bible_player/page/home.dart';
import 'package:flutter/material.dart';

import '../common/play_panel.dart';
import 'favorites.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  _loadRouteArguments() {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args == null) return;
    if (args["currentIndex"] == null) return;
    currentIndex = args["currentIndex"];
  }

  @override
  Widget build(BuildContext context) {
    _loadRouteArguments();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: Colors.red,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: "Favorites",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: [const Home(), const Favorites()][currentIndex]),
          PlayPanel(),
        ],
      ),
    );
  }
}
