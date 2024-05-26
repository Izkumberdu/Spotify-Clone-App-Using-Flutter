import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double width;
  final double height;
  final Color color;
  final bool hasBorder;
  final String? imagePath;

  const Button({
    required Key key,
    required this.text,
    required this.textStyle,
    required this.width,
    required this.height,
    required this.color,
    this.hasBorder = false,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(90),
        border: hasBorder ? Border.all(color: Colors.white) : null,
      ),
      child: Row(
        mainAxisAlignment: imagePath != null
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Row(
              children: [
                const SizedBox(width: 16),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(imagePath!),
                ),
                const SizedBox(width: 8), 
              ],
            ),
          Expanded(
            child: Text(
              text,
              style: textStyle,
              textAlign:
                  TextAlign.center, 
            ),
          ),
        ],
      ),
    );
  }
}
