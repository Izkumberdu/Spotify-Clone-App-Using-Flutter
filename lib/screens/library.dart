// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Library extends ConsumerWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);
    final Size screenSize = MediaQuery.of(context).size;
    final selectedTile = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Column(
              children: [
                topRow(),
                const SizedBox(height: 20),
                categories(context, ref),
                const SizedBox(height: 20),
                filters(),
                const SizedBox(height: 10),
                Visibility(
                  visible: selectedTile == 'Playlists',
                  child: likedSongs(),
                ),                
                Visibility(
                  visible: selectedTile == 'Playlists',
                  child: playlistList(context),
                ),
                Visibility(
                  visible: selectedTile == 'Artists',
                  child: artistList(context),
                ),
                Visibility(
                  visible: selectedTile == 'Albums',
                  child: albumList(context),
                ),
                Visibility(
                  visible: selectedTile == 'Podcasts & Shows',
                  child: newEpisodes(),
                ),                  
                Visibility(
                  visible: selectedTile == 'Podcasts & Shows',
                  child: podcastList(context),
                ),                                
        
              ],
            ),
          ),
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

  SizedBox podcastList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Adjusts the size of the ListView to its contents
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
            title: Text('Playlist ${index + 1}', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('Playlist ${index + 1}', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
          );
        },
      ),
    );
  }

  SizedBox albumList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Adjusts the size of the ListView to its contents
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
            title: Text('Album ${index + 1}', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('Album ${index + 1}', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
          );
        },
      ),
    );
  }


  SizedBox artistList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Adjusts the size of the ListView to its contents
        padding: EdgeInsets.zero,
        itemCount: 10, // replace with actual playlist song count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 60, 
              height: 60,
              decoration: BoxDecoration( //replace with actual stuff from the songs
                color: Colors.amber,
                shape: BoxShape.circle
              ),
            ),
            title: Text('Artist ${index + 1}', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('Artist', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
          );
        },
      ),
    );
  }

  SizedBox playlistList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Adjusts the size of the ListView to its contents
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
            title: Text('Playlist ${index + 1}', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('Playlist ${index + 1}', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
          );
        },
      ),
    );
  }

  Row filters() {
    return Row(
      children: [
        const Icon(Icons.swap_vert, color: Colors.white, size: 20),
        const SizedBox(width: 5),        
        const Expanded(
          child: DropdownFilter(),
        ),
        const Spacer(),
        Container(
          width: 15,
          height: 16,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/icons/gridview.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget likedSongs() {
                      return ListTile(
                      leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/icons/likedsongs.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text('Liked Songs', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        subtitle: Row(
                          children: [
                            Image.asset('assets/images/icons/pin.png', width: 15, height: 15),
                            Text('Playlist • 10 songs', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),                            
                          ],
                        ),

                      );
  }

  Widget newEpisodes() {
                      return ListTile(
                      leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/icons/episode.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text('New Episodes', style: GoogleFonts.sen(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        subtitle: Row(
                          children: [
                            Image.asset('assets/images/icons/pin.png', width: 15, height: 15),
                            Text('Updated __ days ago', style: GoogleFonts.sen(color: const Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),                            
                          ],
                        ),

                      );
  }  

  SizedBox categories(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          buildTile(context, ref, 'Playlists'),
          buildTile(context, ref, 'Artists'),
          buildTile(context, ref, 'Albums'),
          buildTile(context, ref, 'Podcasts & Shows'),
        ],
      ),
    );
  }

  Row topRow() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/profilepic.png'), // change with actual profile pic of user
              fit: BoxFit.cover, 
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Your Library',
          style: GoogleFonts.sen(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/icons/add.png'), 
              fit: BoxFit.cover, 
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTile(BuildContext context, WidgetRef ref, String tileText) {
    final selectedTile = ref.watch(selectedCategoryProvider);
    final isSelected = selectedTile == tileText;

    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = tileText;
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : kBlack,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: const Color(0xFF7F7F7F),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(11, 5, 11, 5),
            child: Text(
              tileText,
              style: GoogleFonts.sen(
                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

}

  class DropdownFilter extends StatefulWidget {
    const DropdownFilter({super.key});

    @override
    _DropdownFilterState createState() => _DropdownFilterState();
  }

  class _DropdownFilterState extends State<DropdownFilter> {
    String _selectedFilter = 'Recently Played';

    final List<String> _filterOptions = [
      'Recently Played',
      'Most Played',
      'Recently Added',
      'Alphabetically',
    ];

    @override
    Widget build(BuildContext context) {
      return DropdownButton<String>(
        value: _selectedFilter,
        dropdownColor: Colors.black,
        icon: const Icon(Icons.arrow_drop_down, color: kBlack),
        isExpanded: true,
        underline: Container(),
        style: GoogleFonts.sen(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedFilter = newValue!;
          });
        },
        items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsetsDirectional.zero,
              child: Text(
                value,
                style: GoogleFonts.sen(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }


