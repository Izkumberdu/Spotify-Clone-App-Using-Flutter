import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/provider/providers.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);

    void _onTapped(int index) {
      ref.read(navbarIndexProvider.notifier).state = index;
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
    }

    return Scaffold(
      bottomNavigationBar:
          BotNavBar(currentIndex: navbarIndex, onTap: _onTapped),
    );
  }
}
