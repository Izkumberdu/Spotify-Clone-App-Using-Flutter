import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/styles/app_styles.dart';

class PlaylistViewPage extends StatefulWidget {
  const PlaylistViewPage({Key? key}) : super(key: key);

  @override
  _PlaylistViewPageState createState() => _PlaylistViewPageState();
}

class _PlaylistViewPageState extends State<PlaylistViewPage> {
  int navbarIndex = 2; // Initially setting it to the library index

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          gradient(screenSize),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Column(
                    children: [
                      backChevron(context),
                      const SizedBox(height: 30),
                      searchBar(),
                      const SizedBox(height: 35),
                      bigPicture(),
                      const SizedBox(height: 30),
                      albumName(),
                      const SizedBox(height: 5),
                      spotifyLabel(),
                      const SizedBox(height: 5),
                      buttonControls(),
                      const SizedBox(height: 5)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: songList(screenSize),
                )
              ],
            ),
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

  Container gradient(Size screenSize) {
    return Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF78644C),
                const Color(0xFF78644C),
                kBlack.withOpacity(0.7),
                const Color(0xFF121212),
              ],
              stops: const [0.0, 0.4, 0.65, 0.8],
            ),
          ),
        );
  }

  SizedBox songList(Size screenSize) {
    return SizedBox(                  
                  width: screenSize.width,
                  height: 250,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 5, 
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
                    '23 likes • 15m 30s', // change to be based on playlist
                    style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                );
  }

  Row spotifyLabel() {
    return Row(
                            children: [
                              Image.asset(
                                'assets/images/icons/logo.png', 
                                width: 24.0, 
                                height: 24.0, 
                              ),
                              const SizedBox(width: 5.0), 
                              Text(
                              'Spotify', //change to be based on playlist
                              style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
  }

  Align albumName() {
    return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New and approved indie pop. Cover: No Rome', //change to be based on playlist
                    style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                );
  }

  Container bigPicture() {
    return Container(
      width: 250,
      height: 250,
      child: Image.asset('assets/images/genreImages/indie.jpg', fit: BoxFit.cover),
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

  Widget backChevron(BuildContext context) {
    return GestureDetector(
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
    );
  }

}