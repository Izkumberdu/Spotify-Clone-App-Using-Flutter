import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/models/artist.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/styles/app_styles.dart';

class ChooseArtist extends StatelessWidget {
  final String email;
  final String password;
  final String name;

  const ChooseArtist({
    required this.email,
    required this.password,
    required this.name,
    super.key,
  });

  Future<List<Artist>> _fetchArtists() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('artists').get();
    return snapshot.docs.map((doc) => Artist.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Artist>>(
      future: _fetchArtists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(child: Text('No artists found')),
          );
        }

        return _ChooseArtistPage(
          email: email,
          password: password,
          name: name,
          artists: snapshot.data!,
        );
      },
    );
  }
}

class _ChooseArtistPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final List<Artist> artists;

  const _ChooseArtistPage({
    required this.email,
    required this.password,
    required this.name,
    required this.artists,
  });

  @override
  State<_ChooseArtistPage> createState() => _ChooseArtistPageState();
}

class _ChooseArtistPageState extends State<_ChooseArtistPage> {
  final List<Artist> _selectedArtists = [];

  void _submit() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'favorite_artists': _selectedArtists.map((artist) => artist.name).toList(),
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
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
      body: Padding(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          backgroundImage: NetworkImage(artist.imageURL),
                          radius: 55,
                          child: isSelected
                              ? const Icon(Icons.check_circle, color: kGreen, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          artist.name,
                          textAlign: TextAlign.center,
                          style: SenMedium.copyWith(fontSize: 14, color: kWhite),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: _selectedArtists.length >= 3 ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                child: Text(
                  'Next',
                  style: SenSemiBold.copyWith(fontSize: 15, color: kBlack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
