import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Library extends ConsumerWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Colors.amber,
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(),
                      Text('data'),
                      Container()
                    ],
                  )
                ],
              ),
              
            ),
          )
        ),
      ),
      bottomNavigationBar: BotNavBar(
        currentIndex: navbarIndex,
        onTap: (index) {
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
        },
      ),
    );
  }


}

