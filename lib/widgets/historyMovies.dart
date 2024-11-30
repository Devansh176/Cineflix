import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class HistoryMovies extends StatelessWidget {
  const HistoryMovies({super.key, required this.historyMovies});
  final List historyMovies;

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
            'Historical Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.39,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: historyMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: historyMovies[index]['original_name'] ?? historyMovies[index]['title'],
                          bannerUrl: historyMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+historyMovies[index]['backdrop_path'] : '',
                          posterUrl: historyMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+historyMovies[index]['poster_path'] : '',
                          description: historyMovies[index]['overview'] ?? 'No description available',
                          vote: historyMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: historyMovies[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+historyMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          historyMovies[index]['original_name'] != null? historyMovies[index]['original_name'] : historyMovies[index]['title'],
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
