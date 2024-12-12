import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class Comedy extends StatelessWidget {
  const Comedy({super.key, required this.comedySeries});
  final List comedySeries;

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
            'Comedy Series',
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
              itemCount: comedySeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: comedySeries[index]['original_name'] != null? comedySeries[index]['original_name'] : 'Loading',
                          bannerUrl: comedySeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+comedySeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: comedySeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+comedySeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: comedySeries[index]['overview'] ?? 'No description available',
                          vote: comedySeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: comedySeries[index]['first_air_date'] ?? 'Unknown',
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
                                comedySeries[index]['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500' + comedySeries[index]['poster_path']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          comedySeries[index]['original_name'] != null? comedySeries[index]['original_name'] : 'Loading',
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
