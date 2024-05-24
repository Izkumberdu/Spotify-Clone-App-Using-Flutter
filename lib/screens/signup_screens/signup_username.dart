import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/screens/signup_screens/signup_artist.dart';
import 'package:lettersquared/screens/signup_screens/signup_password.dart';
import 'package:lettersquared/services/firebase_auth.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/components/button.dart';

class SignUpUsername extends StatelessWidget {
  final String email;
  final String password;
  final TextEditingController nameController = TextEditingController();

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  SignUpUsername({
    required this.email,
    required this.password,
    super.key,
  });

  void _next(BuildContext context) async {
    User? user = await _firebaseAuthService.signUpWithEmailAndPassword(
        context, email, password);

    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'name': nameController.text,
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpArtist(
                  email: email,
                  password: password,
                  name: nameController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        title: Text(
          "Create account",
          style: SenBold.copyWith(fontSize: 16, color: kWhite),
        ),
        centerTitle: true,
        backgroundColor: kBlack,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPassword(email: email)));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's your name?",
                    style: SenBold.copyWith(fontSize: 20, color: kWhite),
                  ),
                  TextField(
                    controller: nameController,
                    cursorColor: kDarkGrey,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kGrey,
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
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "This appears on your Spotify profile.",
                    style: SenBold.copyWith(fontSize: 8, color: kWhite),
                  ),
                  const SizedBox(
                    height: 31,
                  ),
                  const Divider(
                    color: kWhite,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "By tapping on “Create account”, you agree to the spotify Terms of Use.",
                    style: SenMedium.copyWith(fontSize: 10, color: kWhite),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Terms of Use",
                    style: SenMedium.copyWith(fontSize: 10, color: kGreen),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "To learn more about how Spotify collect, uses, shares and protects your personal data, Please see the Spotify Privacy Policy.",
                    style: SenMedium.copyWith(fontSize: 10, color: kWhite),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Privacy Policy",
                    style: SenMedium.copyWith(fontSize: 10, color: kGreen),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please send me news and offers from Spotify.",
                    style: SenMedium.copyWith(fontSize: 10, color: kWhite),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Share my registration data with Spotify’s content providers for marketing purposes.",
                    style: SenMedium.copyWith(fontSize: 10, color: kWhite),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                child: GestureDetector(
                  onTap: () => _next(context),
                  child: Button(
                    key: const ValueKey("su2_next"),
                    text: "Next",
                    textStyle:
                        SenSemiBold.copyWith(fontSize: 15, color: kBlack),
                    width: 82,
                    height: 42,
                    color: const Color(0xff535353),
                  ),
                ),
              ),
              const SizedBox(
                height: 96,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
