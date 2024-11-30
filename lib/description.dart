import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String name, description, bannerUrl, posterUrl, vote, launch_on;
  const Description({super.key, required this.name, required this.description, required this.bannerUrl, required this.posterUrl, required this.vote, required this.launch_on});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: height * 0.3,
            child: Image.network(bannerUrl,),
          ),
          SizedBox(height: height * 0.005,),
          Center(
            child: Text(
              name,
              style: GoogleFonts.ibarraRealNova(
                fontSize: fontSize * 1.7,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: height * 0.02,),
          Padding(
            padding: EdgeInsets.only(left: padding * 0.7,),
            child: Column(
              spacing: height * 0.01,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⭐ Rating : $vote',
                  style: GoogleFonts.taiHeritagePro(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                  ),
                ),
                Text('Release date : $launch_on',
                  style: GoogleFonts.taiHeritagePro(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.9,
                  ),
                ),
                SizedBox(height: height * 0.01,),
                Container(
                  height: height * 0.27,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20,),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        posterUrl,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02,),
                Padding(
                  padding: EdgeInsets.all(padding * 0.6),
                  child: Text(
                    description,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize * 0.9,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
