import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/models/artist.dart';
import 'package:lettersquared/screens/signup3.dart';
import 'package:lettersquared/styles/app_styles.dart';

class ChooseArtist extends StatefulWidget {
  const ChooseArtist({super.key});

  @override
  State<ChooseArtist> createState() => _ChooseArtistState();
}

class _ChooseArtistState extends State<ChooseArtist> {
  List<Artist> _artists = [];
  List<Artist> _selectedArtists = [];

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  void _fetchArtists() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('artists').get();
    setState(() {
      _artists = snapshot.docs.map((doc) => Artist.fromDocument(doc)).toList();
    });
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
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const Signup3())));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xff030303),
                borderRadius: BorderRadius.circular(50)),
            child: const Icon(
              Icons.chevron_left,
              color: kWhite,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 31, right: 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ]),
            const SizedBox(height: 21,)
          ],
        ),
      ),
    );
  }
}
