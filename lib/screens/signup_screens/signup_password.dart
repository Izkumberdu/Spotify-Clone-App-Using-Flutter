import 'package:flutter/material.dart';
import 'package:lettersquared/screens/signup_screens/signup_email.dart';
import 'package:lettersquared/screens/signup_screens/signup_username.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/components/button.dart';

class SignUpPassword extends StatelessWidget {
  final String email;
  final TextEditingController passwordController = TextEditingController();

  SignUpPassword({required this.email, super.key});

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
                context, MaterialPageRoute(builder: ((context) => SignUpEmail())));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create a password",
              style: SenBold.copyWith(fontSize: 20, color: kWhite),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
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
              "Use at least 8 characters.",
              style: SenBold.copyWith(fontSize: 8, color: kWhite),
            ),
            const SizedBox(
              height: 43,
            ),
            Center(
              child: GestureDetector(
                onTap:() => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => SignUpUsername(email: email, password: passwordController.text))
                    )
                  )
                },
                child: Button(
                  key: const ValueKey("su2_next"),
                  text: "Next",
                  textStyle: SenSemiBold.copyWith(fontSize: 15, color: kBlack),
                  width: 82,
                  height: 42,
                  color: const Color(0xff535353),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
