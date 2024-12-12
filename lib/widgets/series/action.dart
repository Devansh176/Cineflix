import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class ActionSeries extends StatelessWidget {
  const ActionSeries({super.key, required this.actionSeries});
  final List actionSeries;

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
            'Action and Adventure Series',
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
              itemCount: actionSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: actionSeries[index]['original_name'] != null? actionSeries[index]['original_name'] : 'Loading',
                          bannerUrl: actionSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+actionSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: actionSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+actionSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: actionSeries[index]['overview'] ?? 'No description available',
                          vote: actionSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: actionSeries[index]['first_air_date'] ?? 'Unknown',
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
                                actionSeries[index]['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500' + actionSeries[index]['poster_path']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          actionSeries[index]['original_name'] != null? actionSeries[index]['original_name'] : 'Loading',
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
