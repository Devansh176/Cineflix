import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ActionMovies extends StatefulWidget {
  const ActionMovies({super.key, required this.actionMovies});
  final List actionMovies;

  @override
  State<ActionMovies> createState() => _ActionMoviesState();
}

class _ActionMoviesState extends State<ActionMovies> {
  late Box actionBox;
  List cachedActionMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget actionMovies: ${widget.actionMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      actionBox = await Hive.openBox('ActionMoviesBox');
      print("Hive Box Opened Successfully");
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
    final cachedData = actionBox.get('actionMovies');
    if (cachedData != null) {
      print("Cached data found in action: ${cachedData.length}");
      setState(() {
        cachedActionMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed actionMovies.");
      setState(() {
        cachedActionMovies = widget.actionMovies;
      });
      actionBox.put('actionMovies', widget.actionMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedActionMovies.length}");

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
            'Action Movies',
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
              itemCount: cachedActionMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedActionMovies[index]['original_name'] ?? cachedActionMovies[index]['title'],
                          bannerUrl: cachedActionMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedActionMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedActionMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedActionMovies[index]['poster_path'] : '',
                          description: cachedActionMovies[index]['overview'] ?? 'No description available',
                          vote: cachedActionMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedActionMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedActionMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedActionMovies[index]['original_name'] != null? cachedActionMovies[index]['original_name'] : cachedActionMovies[index]['title'],
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
