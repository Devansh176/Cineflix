import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiMysteryMovies extends StatefulWidget {
  const HindiMysteryMovies({super.key, required this.hindiMysteryMovies});
  final List hindiMysteryMovies;

  @override
  State<HindiMysteryMovies> createState() => _HindiMysteryMoviesState();
}

class _HindiMysteryMoviesState extends State<HindiMysteryMovies> {
  late Box mysteryBox;
  List cachedMysteryMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget mysteryMovies: ${widget.hindiMysteryMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      mysteryBox = await Hive.openBox('MysteryMoviesBox');
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
    final cachedData = mysteryBox.get('mysteryHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedMysteryMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed mysteryMovies.");
      setState(() {
        cachedMysteryMovies = widget.hindiMysteryMovies;
      });
      mysteryBox.put('mysteryHindiMovies', widget.hindiMysteryMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedMysteryMovies.length}");

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
            'Mystery Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.39,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cachedMysteryMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedMysteryMovies[index]['original_name'] ?? cachedMysteryMovies[index]['title'],
                          bannerUrl: cachedMysteryMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedMysteryMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedMysteryMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedMysteryMovies[index]['poster_path'] : '',
                          description: cachedMysteryMovies[index]['overview'] ?? 'No description available',
                          vote: cachedMysteryMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedMysteryMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedMysteryMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedMysteryMovies[index]['original_name'] != null? cachedMysteryMovies[index]['original_name'] : cachedMysteryMovies[index]['title'],
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
