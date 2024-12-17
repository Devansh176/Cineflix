import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HorrorMovies extends StatefulWidget {
  const HorrorMovies({super.key, required this.horrorMovies});
  final List horrorMovies;

  @override
  State<HorrorMovies> createState() => _HorrorMoviesState();
}

class _HorrorMoviesState extends State<HorrorMovies> {
  late Box horrorBox;
  List cachedHorrorMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget horrorMovies: ${widget.horrorMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      horrorBox = await Hive.openBox('HorrorMoviesBox');
      print("Horror Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        loadMovies();
      }
    }
  }

  void loadMovies() {
    final cachedData = horrorBox.get('horrorMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in horror : ${cachedData.length}");
      setState(() {
        cachedHorrorMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed horrorMovies.");
      setState(() {
        cachedHorrorMovies = widget.horrorMovies;
      });
      horrorBox.put('horrorMovies', widget.horrorMovies);
      print("HorrorMovies data saved to Hive: ${widget.horrorMovies.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering horror movies: ${cachedHorrorMovies.length}");

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
              itemCount: cachedHorrorMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedHorrorMovies[index]['original_name'] ?? cachedHorrorMovies[index]['title'],
                          bannerUrl: cachedHorrorMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedHorrorMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedHorrorMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedHorrorMovies[index]['poster_path'] : '',
                          description: cachedHorrorMovies[index]['overview'] ?? 'No description available',
                          vote: cachedHorrorMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedHorrorMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedHorrorMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedHorrorMovies[index]['original_name'] != null? cachedHorrorMovies[index]['original_name'] : cachedHorrorMovies[index]['title'],
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
