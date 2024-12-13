import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class HorrorMovies extends StatelessWidget {
  const HorrorMovies({super.key, required this.horrorMovies});
  final List horrorMovies;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    String getValidImageUrl(String? url) {
      return (url != null && url.isNotEmpty)
          ? 'https://image.tmdb.org/t/p/w500$url'
          : 'https://via.placeholder.com/300';
    }

    return Container(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horror Movies',
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
              itemCount: horrorMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: horrorMovies[index]['original_name'] ?? horrorMovies[index]['title'],
                          bannerUrl: horrorMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+horrorMovies[index]['backdrop_path'] : '',
                          posterUrl: horrorMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+horrorMovies[index]['poster_path'] : '',
                          description: horrorMovies[index]['overview'] ?? 'No description available',
                          vote: horrorMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: horrorMovies[index]['release_date'] ?? 'Unknown',
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
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(horrorMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          horrorMovies[index]['original_name'] != null? horrorMovies[index]['original_name'] : horrorMovies[index]['title'],
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
