import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String text;
  final IconData icon;

  InfoCard({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: HexColor("#C35E12"),
          ),
          title: Text(
            text,
            style: GoogleFonts.sourceSansPro(
                textStyle: TextStyle(color: HexColor("#C35E12"), fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
