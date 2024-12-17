import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FamilyMovies extends StatefulWidget {
  const FamilyMovies({super.key, required this.familyMovies});
  final List familyMovies;

  @override
  State<FamilyMovies> createState() => _FamilyMoviesState();
}

class _FamilyMoviesState extends State<FamilyMovies> {
  late Box familyBox;
  List cachedFamilyMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget actionMovies: ${widget.familyMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      familyBox = await Hive.openBox('FamilyMoviesBox');
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
    final cachedData = familyBox.get('familyMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedFamilyMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed familyMovies.");
      setState(() {
        cachedFamilyMovies = widget.familyMovies;
      });
      familyBox.put('familyMovies', widget.familyMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedFamilyMovies.length}");

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
            'Family Movies',
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
              itemCount: cachedFamilyMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedFamilyMovies[index]['original_name'] ?? cachedFamilyMovies[index]['title'],
                          bannerUrl: cachedFamilyMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedFamilyMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedFamilyMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedFamilyMovies[index]['poster_path'] : '',
                          description: cachedFamilyMovies[index]['overview'] ?? 'No description available',
                          vote: cachedFamilyMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedFamilyMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedFamilyMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedFamilyMovies[index]['original_name'] != null? cachedFamilyMovies[index]['original_name'] : cachedFamilyMovies[index]['title'],
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
