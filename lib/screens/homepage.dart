import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);

    void onTapped(int index) {
      ref.read(navbarIndexProvider.notifier).state = index;
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
    }

    return Scaffold(
      backgroundColor: kBlack,
      bottomNavigationBar:
          BotNavBar(currentIndex: navbarIndex, onTap: onTapped),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(31),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Played",
                    style: SenBold.copyWith(fontSize: 19, color: kWhite),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/images/icons/notification.png"),
                      ),
                      const SizedBox(width: 22,),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/images/icons/orientation lock.png"),
                      ),
                      const SizedBox(width: 22,),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/images/icons/Settings.png"),
                      )
                    ],
                  )
                ],
              ),
              Row(
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
