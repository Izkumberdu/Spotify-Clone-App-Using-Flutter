import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/styles/app_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int navbarIndex = 2; // Initially setting it to the library index

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              headerText(screenSize),
              const SizedBox(height: 20),
              userIs(),
              const SizedBox(height: 20),
              settingTile('Account'),
              settingTile('Data Saver'),
              settingTile('Languages'),
              settingTile('Playback'),
              settingTile('Explicit Content'),
              settingTile('Devices'),
              settingTile('Car'),
              settingTile('Social'),
              settingTile('Voice Assistant & Apps'),
              settingTile('Audio Quality'),
              settingTile('Storage'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BotNavBar(
        currentIndex: navbarIndex,
        onTap: (index) {
          setState(() {
            navbarIndex = index;
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
        },
      ),
    );
  }

  ListTile userIs() {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle, // Make the container circular
          image: DecorationImage(
            image: AssetImage('assets/images/profilepic.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_sharp, color: Colors.white, size: 30),
      title: Text(
        'maya',
        style: GoogleFonts.sen(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        'View profile',
        style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Container headerText(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: 80,
      color: Color.fromARGB(255, 34, 34, 34),
      child: Padding(
        padding: EdgeInsets.fromLTRB(45, 20, 45, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
            ),

            const Spacer(),
            Text('Settings', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget settingTile(String s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: Row(
        children: [
          Text(
            s,
            style: GoogleFonts.sen(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right_sharp, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
