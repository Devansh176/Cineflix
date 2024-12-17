import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiHistoryMovies extends StatefulWidget {
  const HindiHistoryMovies({super.key, required this.hindiHistoryMovies});
  final List hindiHistoryMovies;

  @override
  State<HindiHistoryMovies> createState() => _HindiHistoryMoviesState();
}

class _HindiHistoryMoviesState extends State<HindiHistoryMovies> {
  late Box historyBox;
  List cachedHistoryMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget historyMovies: ${widget.hindiHistoryMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      historyBox = await Hive.openBox('HistoryMoviesBox');
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
    final cachedData = historyBox.get('historyHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedHistoryMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed historyMovies.");
      setState(() {
        cachedHistoryMovies = widget.hindiHistoryMovies;
      });
      historyBox.put('historyHindiMovies', widget.hindiHistoryMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedHistoryMovies.length}");

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
            'Historical Movies',
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
              itemCount: cachedHistoryMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedHistoryMovies[index]['original_name'] ?? cachedHistoryMovies[index]['title'],
                          bannerUrl: cachedHistoryMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedHistoryMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedHistoryMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedHistoryMovies[index]['poster_path'] : '',
                          description: cachedHistoryMovies[index]['overview'] ?? 'No description available',
                          vote: cachedHistoryMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedHistoryMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedHistoryMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedHistoryMovies[index]['original_name'] != null? cachedHistoryMovies[index]['original_name'] : cachedHistoryMovies[index]['title'],
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
