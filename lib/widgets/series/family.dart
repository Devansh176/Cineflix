import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class FamilySeries extends StatelessWidget {
  const FamilySeries({super.key, required this.familyShow});
  final List familyShow;

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
            'Family Show',
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
              itemCount: familyShow.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: familyShow[index]['original_name'] != null? familyShow[index]['original_name'] : 'Loading',
                          bannerUrl: familyShow[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+familyShow[index]['backdrop_path'] : familyShow[index]['poster_path'],
                          posterUrl: familyShow[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+familyShow[index]['poster_path'] : familyShow[index]['backdrop_path'],
                          description: familyShow[index]['overview'] ?? 'No description available',
                          vote: familyShow[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: familyShow[index]['first_air_date'] ?? 'Unknown',
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
                                familyShow[index]['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500' + familyShow[index]['poster_path']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          familyShow[index]['original_name'] != null? familyShow[index]['original_name'] : 'Loading',
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
