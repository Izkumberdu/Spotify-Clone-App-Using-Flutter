// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/models/artist.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/services/firebase_auth.dart';
import 'package:lettersquared/styles/app_styles.dart';

class SignUpArtist extends StatelessWidget {
  final String email;
  final String password;
  final String name;
  SongHandler songHandler;

  SignUpArtist({
    required this.email,
    required this.password,
    required this.name,
    super.key,
    required this.songHandler,
  });

  Future<List<Artist>> _fetchArtists() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('artists').get();
    return snapshot.docs.map((doc) => Artist.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Artist>>(
      future: _fetchArtists(),
      builder: (context, artistSnapshot) {
        if (artistSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (artistSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${artistSnapshot.error}')),
          );
        }
        if (!artistSnapshot.hasData || artistSnapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No artists found')),
          );
        }

        return _SignUpArtistPage(
          email: email,
          password: password,
          name: name,
          artists: artistSnapshot.data!,
          songHandler: songHandler,
        );
      },
    );
  }
}

class _SignUpArtistPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final List<Artist> artists;
  SongHandler songHandler;

  _SignUpArtistPage(
      {required this.email,
      required this.password,
      required this.name,
      required this.artists,
      required this.songHandler});

  @override
  State<_SignUpArtistPage> createState() => _SignUpArtistPageState();
}

class _SignUpArtistPageState extends State<_SignUpArtistPage> {
  final List<Artist> _selectedArtists = [];
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  void _submit() async {
    User? user = await _firebaseAuthService.getCurrentUser();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'favorite_artists':
            _selectedArtists.map((artist) => artist.id).toList(),
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homepage(
                    songHandler: widget.songHandler,
                  )));
    } else {
      // nofin
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        title: Text(
          "Choose 3 or more artists you like.",
          style: SenBold.copyWith(fontSize: 16, color: kWhite),
        ),
        centerTitle: true,
        backgroundColor: kBlack,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff030303),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: kWhite,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  cursorColor: kDarkGrey,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kWhite,
                    hintText: "Search",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: widget.artists.length,
                    itemBuilder: (context, index) {
                      Artist artist = widget.artists[index];
                      bool isSelected = _selectedArtists.contains(artist);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedArtists.remove(artist);
                            } else {
                              _selectedArtists.add(artist);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(artist.imageURL),
                              onBackgroundImageError: (exception, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error loading image: $exception'),
                                  ),
                                );
                              },
                              backgroundColor: Colors.grey,
                              child: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: kGreen, size: 40)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artist.name,
                              textAlign: TextAlign.center,
                              style: SenMedium.copyWith(
                                  fontSize: 10, color: kWhite),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_selectedArtists.length >= 3)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, kBlack],
                  ),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _selectedArtists.length >= 3 ? 16 : -60,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: ElevatedButton(
                onPressed: _selectedArtists.length >= 3 ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: GestureDetector(
                  onTap: _submit,
                  child: Text(
                    'Next',
                    style: SenSemiBold.copyWith(fontSize: 15, color: kBlack),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
