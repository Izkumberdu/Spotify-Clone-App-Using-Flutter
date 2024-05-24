import 'package:flutter/material.dart';
import 'package:lettersquared/styles/app_styles.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  _BotNavBarState createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: kBlack,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: widget.currentIndex == 0
              ? Image.asset('assets/images/navbar/Home_active.png')
              : Image.asset('assets/images/navbar/Home_inactive.png'),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: widget.currentIndex == 1
              ? Image.asset('assets/images/navbar/Search_active.png')
              : Image.asset('assets/images/navbar/Search_inactive.png'),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: widget.currentIndex == 2
              ? Image.asset('assets/images/navbar/Library_active.png')
              : Image.asset('assets/images/navbar/Library_inactive.png'),
          label: 'Your Library',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedLabelStyle: SenMedium.copyWith(fontSize: 13, color: kLightGrey),
      selectedItemColor: kWhite,
      unselectedItemColor: kGrey,
      unselectedLabelStyle: SenMedium.copyWith(fontSize: 13, color: kLightGrey),
    );
  }
}
