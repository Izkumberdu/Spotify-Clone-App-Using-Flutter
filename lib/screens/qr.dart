import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final List<bool> _isSelected = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    // Get the dimensions of the screen
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // Set width and height to screen dimensions
          width: screenSize.width,
          height: screenSize.height,
          color: const Color(0xFF121212),

          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    'assets/images/icons/x.png', 
                                    width: 15, 
                                    height: 15, 
                                  ),
                                ),
                                
              ],
            ),
          ),
        ),
      ),
    );
  }


}
