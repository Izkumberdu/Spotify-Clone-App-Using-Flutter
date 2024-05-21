import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/screens/signup1.dart';
import 'package:lettersquared/screens/signup3.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/components/button.dart';

class Signup2 extends StatelessWidget {
  final String email;
  final TextEditingController passwordController = TextEditingController();
 
  bool _obscureText = true; // rembmemrsm

  Signup2({required this.email, super.key});
  
  Future<void> _register(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: passwordController.text);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Signup3(email: email, password: passwordController.text),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
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
                context, MaterialPageRoute(builder: ((context) => SignUp1())));
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
                onTap: () => _register(context),
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
