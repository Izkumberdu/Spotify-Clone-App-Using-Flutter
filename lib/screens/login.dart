import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/components/button.dart';

class Login extends StatefulWidget {
  SongHandler songHandler;
  Login({super.key, required this.songHandler});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Homepage(
                  songHandler: widget.songHandler,
                )),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Padding(
        padding: const EdgeInsets.all(31),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/icons/logo_white.png"),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Spotify",
                style: SenBold.copyWith(fontSize: 19, color: kWhite),
              ),
              const SizedBox(
                height: 21,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: SenMedium.copyWith(fontSize: 16, color: kWhite),
                  ),
                  TextField(
                    controller: _emailController,
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
                    "Password",
                    style: SenMedium.copyWith(fontSize: 16, color: kWhite),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
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
                    height: 16,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => _login(),
                      child: Button(
                          key: const ValueKey("login"),
                          text: "Log in",
                          textStyle:
                              SenBold.copyWith(fontSize: 15, color: kBlack),
                          width: 90,
                          height: 42,
                          color: kGreen),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
