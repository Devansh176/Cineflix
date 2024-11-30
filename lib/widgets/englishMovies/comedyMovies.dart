import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class ComedyMovies extends StatelessWidget {
  const ComedyMovies({super.key, required this.comedyMovies});
  final List comedyMovies;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    return Container(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comedy Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: comedyMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: comedyMovies[index]['original_name'] ?? comedyMovies[index]['title'],
                          bannerUrl: comedyMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+comedyMovies[index]['backdrop_path'] : '',
                          posterUrl: comedyMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+comedyMovies[index]['poster_path'] : '',
                          description: comedyMovies[index]['overview'] ?? 'No description available',
                          vote: comedyMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: comedyMovies[index]['release_date'] ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: width * 0.4,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50,),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500'+comedyMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          comedyMovies[index]['original_name'] != null? comedyMovies[index]['original_name'] : comedyMovies[index]['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize * 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
