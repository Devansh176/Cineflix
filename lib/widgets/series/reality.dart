import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class Reality extends StatelessWidget {
  const Reality({super.key, required this.realityShow});
  final List realityShow;

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
            'Reality Show',
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
              itemCount: realityShow.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: realityShow[index]['original_name'] != null? realityShow[index]['original_name'] : 'Loading',
                          bannerUrl: realityShow[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+realityShow[index]['backdrop_path'] : realityShow[index]['poster_path'],
                          posterUrl: realityShow[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+realityShow[index]['poster_path'] : realityShow[index]['backdrop_path'],
                          description: realityShow[index]['overview'] ?? 'No description available',
                          vote: realityShow[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: realityShow[index]['first_air_date'] ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50,),
                            image: DecorationImage(
                              image: NetworkImage(
                                realityShow[index]['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500' + realityShow[index]['poster_path']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          realityShow[index]['original_name'] != null? realityShow[index]['original_name'] : 'Loading',
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
