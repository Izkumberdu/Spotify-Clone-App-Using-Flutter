import 'package:flutter/material.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/models/genre.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SearchMenu extends StatefulWidget {
  const SearchMenu({super.key});

  @override
  State<SearchMenu> createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
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
    return Scaffold(
      backgroundColor: kBlack,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search',
                  style: SenBold.copyWith(fontSize: 25, color: kWhite),
                ),
                Image.asset('assets/images/icons/camera.png'),
              ],
            ),
            SizedBox(height: 20),
            searchBar(),
            SizedBox(height: 25),
            Text(
              "Your Top Genres",
              textAlign: TextAlign.left,
              style: SenSemiBold.copyWith(
                fontSize: 18,
                color: kWhite,
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Container(
              height: 138, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: categoryContainer(
                      genres[index].title,
                      genres[index].imagePath,
                      genres[index].color, // Pass color from Genre
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Picks",
                  textAlign: TextAlign.left,
                  style: SenSemiBold.copyWith(
                    fontSize: 18,
                    color: kWhite,
                  ),
                ),
                Image.asset('assets/images/icons/shuffle.png')
              ],
            ),
            SizedBox(
              height: 15,
            ),
            songContainer(),
            SizedBox(
              height: 10,
            ),
            songContainer(),
            SizedBox(
              height: 10,
            ),
            songContainer(),
            SizedBox(
              height: 10,
            ),
            songContainer(),
            SizedBox(
              height: 10,
            ),
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
    width: 393,
    height: 46,
    decoration: BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Image.asset('assets/images/icons/search.png'),
          SizedBox(width: 10),
          Text(
            'Artist, Songs, Podcasts',
            style: SenMedium.copyWith(fontSize: 16, color: kBlack),
          )
        ],
      ),
    ),
  );
}

Widget categoryContainer(String text, String imagePath, Color color) {
  return Container(
    width: 192,
    height: 109,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black45.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Transform.rotate(
            angle: 0.1, // Adjust the tilt angle here
            child: Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget songContainer() {
  return Container(
    width: 393,
    height: 50,
    color: kBlack,
    child: Row(
      children: [
        Image.asset(
          'assets/images/songs/fragile.jpg',
          height: 50,
          width: 50,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fragile",
              style: SenSemiBold.copyWith(fontSize: 16, color: kWhite),
            ),
            SizedBox(height: 5),
            Text(
              "Laufey",
              style: SenSemiBold.copyWith(fontSize: 12, color: kGrey),
            ),
          ],
        ),
        Spacer(),
        Image.asset('assets/images/icons/Play.png'),
        SizedBox(width: 15),
        Image.asset('assets/images/icons/Heart_Solid.png'),
        SizedBox(width: 10),
        Image.asset('assets/images/icons/more.png'),
      ],
    ),
  );
}
