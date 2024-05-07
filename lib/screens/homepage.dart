import 'package:flutter/material.dart';
import 'package:lettersquared/components/bottomNavbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _navbarIndex = 0;
  void _onTapped(int index) {
    setState(() {
      _navbarIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/homepage');
          break;
        case 1:
          Navigator.pushNamed(context, '/searchMenu');
          break;
        case 2:
          Navigator.pushNamed(context, '/library');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BotNavBar(currentIndex: _navbarIndex, onTap: _onTapped),
    );
  }
}
