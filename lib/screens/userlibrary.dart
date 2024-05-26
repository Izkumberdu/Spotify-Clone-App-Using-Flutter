import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/styles/app_styles.dart';

class UserLibraryPage extends StatefulWidget {
  const UserLibraryPage({Key? key}) : super(key: key);

  @override
  _UserLibraryPageState createState() => _UserLibraryPageState();
}

class _UserLibraryPageState extends State<UserLibraryPage> {
  int navbarIndex = 2; // Initially setting it to the library index

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          gradient(screenSize),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        backChevron(),
                        const Spacer(),
                        moreDots(context)
                      ],
                    ),
                    const SizedBox(height: 35),
                    profilePicture(),
                    const SizedBox(height: 35),
                    editProfile(),
                    const SizedBox(height: 50),
                    profileDetails(),
                    const SizedBox(height: 20),
                    playlistText(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    playlistsDown(screenSize),
                    seeAll(),
                  ],
                ),
              )
            ],
          )
        ],
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

  Padding seeAll() {
    return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 25, 0),
                    child: Row(
                      children: [
                        Text(
                          'See all playlists',
                          style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right_sharp, color: Colors.white, size: 30),
                      ],
                    ),
                  );
  }

  Container playlistsDown(Size screenSize) {
    return Container(
                    width: screenSize.width,
                    height: 250,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Set physics to NeverScrollableScrollPhysics
                      itemCount: 3, 
                      itemBuilder: (context, index) {
                        // Replace the arguments with actual data from your list
                        return playlistTile(
                          'assets/images/genreImages/electronic.jpg',
                          'Playlist 1',
                          '1 likes',
                        );
                      },
                    ),
                  );
  }

  Container gradient(Size screenSize) {
    return Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 62, 103, 165),
                Color.fromARGB(255, 62, 103, 165),
                kBlack.withOpacity(0.7),
                const Color(0xFF121212),
              ],
              stops: const [0.0, 0.4, 0.5, 0.7],
            ),
          ),
        );
  }

  Align playlistText() {
    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Playlists',
                        style: GoogleFonts.sen(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)
                      ),
                    );
  }

  SizedBox songList(Size screenSize) {
    return SizedBox(                  
                  width: screenSize.width,
                  height: 250,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10, // replace with actual playlist song count
                    itemBuilder: (context, index) {
                      return ListTile(
                      leading: Container(
                        width: 50, 
                        height: 50,
                        decoration: BoxDecoration( //replace with actual stuff from the songs
                          color: Colors.amber,
                        ),
                      ),
                        title: Text('Song ${index + 1}', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        subtitle: Text('Artist ${index + 1}', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
                        trailing:                                 Image.asset(
                                'assets/images/icons/more-horizontal.png', 
                                width: 30,
                                height: 30,
                              ),
                      );
                    },
                  ),                    
                );
  }

  Row buttonControls() {
    return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          likesDuration(),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/icons/heart-outline.png', 
                                  width: 20, 
                                  height: 20, 
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/icons/download-outline.png', 
                                  width: 20,
                                  height: 20,
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/icons/more-horizontal.png', 
                                  width: 30,
                                  height: 30,
                                ),
                                const Spacer()
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    const Spacer(),
                    ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          'assets/images/icons/greenplay.png', // Path to your image asset
                          fit: BoxFit.cover, // Ensures the image covers the container
                        ),
                      ),
                    )                     
                  ],
                );
  }

  Align likesDuration() {
    return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '1,629,592 likes • 6h 48m', // change to be based on playlist
                    style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                );
  }

  Row profileDetails() {
    return Row(
      children: [
        const SizedBox(width: 20),
        detailTile('23', 'PLAYLISTS'),
        const Spacer(),
        detailTile('58', 'FOLLOWERS'),
        const Spacer(),
        detailTile('43', 'FOLLOWING'),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget detailTile(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.sen(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.sen(
            color: const Color(0xFFB3B3B3),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }



  Widget profilePicture() {
    return ClipOval(
      child: Container(
        width: 120,
        height: 120,
        child: Image.asset('assets/images/profilepic.png', fit: BoxFit.cover),
      ),
    );
  }


  Row searchBar() {
    return Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Find in playlist',
                          hintStyle: GoogleFonts.sen(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF7E6E5B),
                          contentPadding: const EdgeInsets.symmetric(vertical: 5)
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 60,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Sort',
                          hintStyle: GoogleFonts.sen(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF7E6E5B),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                        ),
                      ),
                    ),

                  ],
                );
  }

  Align backChevron() {
    return const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                    color: Colors.white,
                  ),
                );
  }

Widget moreDots(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/settings'); // Navigate to PlaylistViewPage
    },
    child: Align(
      alignment: Alignment.centerRight,
      child: Image.asset(
        'assets/images/icons/more-horizontal.png',
        width: 30,
        height: 30,
      ),
    ),
  );
}

Widget editProfile() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFF3E3F3F),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        'Edit Profile',
        style: GoogleFonts.sen(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)
      ),
    ),
  );
}

Widget playlistTile(String imageAsset, String title, String subtitle) {
  return ListTile(
    leading: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
    ),
    trailing: Icon(Icons.chevron_right_sharp, color: Colors.white, size: 30),
    title: Text(
      title,
      style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    subtitle: Text(
      subtitle,
      style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}


}