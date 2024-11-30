import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class Popular extends StatelessWidget {
  const Popular({super.key, required this.popular});
  final List popular;

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
            'Popular Movies',
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
              itemCount: popular.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: popular[index]['original_name'] != null? popular[index]['original_name'] : popular[index]['title'],
                          bannerUrl: popular[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+popular[index]['backdrop_path'] : '',
                          posterUrl: popular[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+popular[index]['poster_path'] : '',
                          description: popular[index]['overview'] ?? 'No description available',
                          vote: popular[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: popular[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+popular[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          popular[index]['original_name'] != null? popular[index]['original_name'] : popular[index]['title'],
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
