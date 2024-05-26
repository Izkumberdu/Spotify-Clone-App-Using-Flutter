import 'package:flutter/material.dart';
import 'package:lettersquared/components/bottomNavbar.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int _navbarIndex = 2;
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
          Navigator.pushNamed(context, '/playingqueue');
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
