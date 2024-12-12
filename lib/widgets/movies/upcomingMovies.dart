import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class UpcomingMovies extends StatelessWidget {
  const UpcomingMovies({super.key, required this.upcomingMovies});
  final List upcomingMovies;

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
            'Upcoming Movies',
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
              itemCount: upcomingMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: upcomingMovies[index]['original_name'] ?? upcomingMovies[index]['title'],
                          bannerUrl: upcomingMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+upcomingMovies[index]['backdrop_path'] : '',
                          posterUrl: upcomingMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+upcomingMovies[index]['poster_path'] : '',
                          description: upcomingMovies[index]['overview'] ?? 'No description available',
                          vote: upcomingMovies[index]['vote_average']?.toString() ?? 'Not Rated Yet',
                          launch_on: upcomingMovies[index]['first_air_date'] ?? upcomingMovies[index]['release_date'],
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
                                upcomingMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+upcomingMovies[index]['poster_path'] : '',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          upcomingMovies[index]['original_name'] != null? upcomingMovies[index]['original_name'] : upcomingMovies[index]['title'],
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
