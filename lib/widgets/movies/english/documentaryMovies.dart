import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DocumentaryMovies extends StatefulWidget {
  const DocumentaryMovies({super.key, required this.documentaryMovies});
  final List documentaryMovies;

  @override
  State<DocumentaryMovies> createState() => _DocumentaryMoviesState();
}

class _DocumentaryMoviesState extends State<DocumentaryMovies> {
  late Box documentaryBox;
  List cachedDocMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget documentaryMovies: ${widget.documentaryMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      documentaryBox = await Hive.openBox('DocumentaryMoviesBox');
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
    final cachedData = documentaryBox.get('documentaryMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedDocMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed documentaryMovies.");
      setState(() {
        cachedDocMovies = widget.documentaryMovies;
      });
      documentaryBox.put('documentaryMovies', widget.documentaryMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedDocMovies.length}");

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
      padding: EdgeInsets.only(
        top: padding * 0.8,
        left: padding * 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documentary Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            height: height * 0.39,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cachedDocMovies.length,
              separatorBuilder: (context, index) {
                return SizedBox(width: width * 0.04,);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedDocMovies[index]['original_name'] ?? cachedDocMovies[index]['title'],
                          bannerUrl:  cachedDocMovies[index]['backdrop_path'] != null ? 'https://image.tmdb.org/t/p/w500${cachedDocMovies[index]['backdrop_path']}' : '',
                          posterUrl: cachedDocMovies[index]['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${cachedDocMovies[index]['poster_path']}' : '',
                          description: cachedDocMovies[index]['overview'] ?? 'No description available',
                          vote: cachedDocMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedDocMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedDocMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          cachedDocMovies[index]['original_name'] ?? cachedDocMovies[index]['title'] ?? 'Untitled',
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
