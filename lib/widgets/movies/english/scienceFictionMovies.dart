import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ScienceFictionMovies extends StatefulWidget {
  const ScienceFictionMovies({super.key, required this.sciFiMovies});
  final List sciFiMovies;

  @override
  State<ScienceFictionMovies> createState() => _ScienceFictionMoviesState();
}

class _ScienceFictionMoviesState extends State<ScienceFictionMovies> {
  late Box sciFiBox;
  List cachedSciFiMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget sciFiMovies: ${widget.sciFiMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      sciFiBox = await Hive.openBox('RomanceMoviesBox');
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
    final cachedData = sciFiBox.get('sciFiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedSciFiMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed sciFiMovies.");
      setState(() {
        cachedSciFiMovies = widget.sciFiMovies;
      });
      sciFiBox.put('sciFiMovies', widget.sciFiMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedSciFiMovies.length}");

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
            'Science Fiction Movies',
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
              itemCount: cachedSciFiMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedSciFiMovies[index]['original_name'] ?? cachedSciFiMovies[index]['title'],
                          bannerUrl: cachedSciFiMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedSciFiMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedSciFiMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedSciFiMovies[index]['poster_path'] : '',
                          description: cachedSciFiMovies[index]['overview'] ?? 'No description available',
                          vote: cachedSciFiMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedSciFiMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedSciFiMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedSciFiMovies[index]['original_name'] != null? cachedSciFiMovies[index]['original_name'] : cachedSciFiMovies[index]['title'],
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
