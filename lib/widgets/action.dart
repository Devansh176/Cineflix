import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class ActionMovies extends StatelessWidget {
  const ActionMovies({super.key, required this.actionMovies});
  final List actionMovies;

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
            'Action Movies',
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
              itemCount: actionMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: actionMovies[index]['original_name'] ?? actionMovies[index]['title'],
                          bannerUrl: actionMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+actionMovies[index]['backdrop_path'] : '',
                          posterUrl: actionMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+actionMovies[index]['poster_path'] : '',
                          description: actionMovies[index]['overview'] ?? 'No description available',
                          vote: actionMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: actionMovies[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+actionMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          actionMovies[index]['original_name'] != null? actionMovies[index]['original_name'] : actionMovies[index]['title'],
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
