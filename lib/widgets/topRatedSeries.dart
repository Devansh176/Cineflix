import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class TopRatedSeries extends StatelessWidget {
  const TopRatedSeries({super.key, required this.topRatedSeries});
  final List topRatedSeries;

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
            'Top Rated Series',
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
              itemCount: topRatedSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: topRatedSeries[index]['name'] != null? topRatedSeries[index]['original_name'] : topRatedSeries[index]['name'],
                          bannerUrl: topRatedSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+topRatedSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: topRatedSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+topRatedSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: topRatedSeries[index]['overview'] ?? 'No description available',
                          vote: topRatedSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: topRatedSeries[index]['first_air_date'] ?? 'Unknown',
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
                                topRatedSeries[index]['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500' + topRatedSeries[index]['poster_path']
                                    : 'https://via.placeholder.com/150', // Placeholder image
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          topRatedSeries[index]['original_name'] != null? topRatedSeries[index]['original_name'] : 'Loading',
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
