import 'package:flutter/material.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/constants/size_config.dart';
// import 'package:lettersquared/models/genre.dart';
import 'package:lettersquared/styles/app_styles.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _navbarIndex = 1;
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
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: kBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 27,
            ),
            Row(
              children: [
                searchBar(),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: SenMedium.copyWith(fontSize: 15, color: kWhite),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Recent Searches",
              style: SenSemiBold.copyWith(fontSize: 18, color: kWhite),
            )
          ],
        ),
      ),
      bottomNavigationBar:
          BotNavBar(currentIndex: _navbarIndex, onTap: _onTapped),
    );
  }
}

Widget searchBar() {
  return Container(
    width: SizeConfig.blockSizeHorizontal! * 75,
    height: 40,
    decoration: BoxDecoration(
      color: kDarkGrey,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Image.asset('assets/images/icons/search_white.png'),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ',
                hintStyle: SenMedium.copyWith(fontSize: 16, color: kWhite),
                border: InputBorder.none,
              ),
              style: SenMedium.copyWith(fontSize: 16, color: kWhite),
              cursorColor: kBlack,
              onChanged: (value) {},
              onSubmitted: (value) {},
            ),
          ),
        ],
      ),
    ),
  );
}
