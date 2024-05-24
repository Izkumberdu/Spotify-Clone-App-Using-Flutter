import 'package:flutter/material.dart';
import 'package:lettersquared/components/button.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/login.dart';
import 'package:lettersquared/screens/signup_screens/signup_email.dart';
import 'package:lettersquared/styles/app_styles.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //Image.asset("assets/images/bgs/start_bg.png"),
            Image.asset("assets/images/icons/logo_white.png"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Millions of Songs.\nFree on Spotify.",
              style: SenBold,
            ),
            const SizedBox(
              height: 22,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => SignUpEmail())));
                  },
                  child: Button(
                    key: const ValueKey("start_signup"),
                    text: "Sign up free",
                    textStyle: SenBold.copyWith(color: kBlack, fontSize: 16),
                    width: 337,
                    height: 49,
                    color: kGreen,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Button(
                  key: const ValueKey("start_google"),
                  text: "Continue with Google",
                  textStyle: SenBold.copyWith(color: kWhite, fontSize: 16),
                  width: 337,
                  height: 49,
                  color: kBlack,
                  hasBorder: true,
                  imagePath: "assets/images/icons/google.png",
                ),
                const SizedBox(
                  height: 12,
                ),
                Button(
                  key: const ValueKey("start_facebook"),
                  text: "Continue with Facebook",
                  textStyle: SenBold.copyWith(color: kWhite, fontSize: 16),
                  width: 337,
                  height: 49,
                  color: kBlack,
                  hasBorder: true,
                  imagePath: "assets/images/icons/facebook.png",
                ),
                const SizedBox(
                  height: 12,
                ),
                Button(
                  key: const ValueKey("start_apple"),
                  text: "Continue with Apple",
                  textStyle: SenBold.copyWith(color: kWhite, fontSize: 16),
                  width: 337,
                  height: 49,
                  color: kBlack,
                  hasBorder: true,
                  imagePath: "assets/images/icons/apple.png",
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const Homepage()) //change to login!!!!!
                            ));
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Login())));
                    },
                    child: Button(
                      key: const ValueKey("start_login"),
                      text: "Log in",
                      textStyle: SenBold.copyWith(color: kWhite, fontSize: 16),
                      width: 337,
                      height: 49,
                      color: kBlack,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 54,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
