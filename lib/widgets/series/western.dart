import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class WesternSeries extends StatelessWidget {
  const WesternSeries({super.key, required this.westernSeries});
  final List westernSeries;

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
            'Western Series',
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
              itemCount: westernSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: westernSeries[index]['original_name'] != null? westernSeries[index]['original_name'] : 'Loading',
                          bannerUrl: westernSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+westernSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: westernSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+westernSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: westernSeries[index]['overview'] ?? 'No description available',
                          vote: westernSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: westernSeries[index]['first_air_date'] ?? 'Unknown',
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
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(westernSeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          westernSeries[index]['original_name'] != null? westernSeries[index]['original_name'] : 'Loading',
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
