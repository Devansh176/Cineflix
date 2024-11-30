import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class modifiedText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const modifiedText({super.key, required this.text, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.aboreto(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
