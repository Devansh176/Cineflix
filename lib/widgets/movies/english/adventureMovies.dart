import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AdventureMovies extends StatefulWidget {
  const AdventureMovies({super.key, required this.adventureMovies});
  final List adventureMovies;

  @override
  State<AdventureMovies> createState() => _AdventureMoviesState();
}

class _AdventureMoviesState extends State<AdventureMovies> {
  late Box adventureBox;
  List cachedAdventureMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget adventureMovies: ${widget.adventureMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      adventureBox = await Hive.openBox('AdventureMoviesBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        // Load movies after initializing Hive
        loadMovies();
      }
    }
  }

  void loadMovies() {
    final cachedData = adventureBox.get('adventureMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedAdventureMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed adventureMovies.");
      setState(() {
        cachedAdventureMovies = widget.adventureMovies;
      });
      adventureBox.put('adventureMovies', widget.adventureMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    print("Rendering movies: ${cachedAdventureMovies.length}");

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
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adventure Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02),
          cachedAdventureMovies.isEmpty
              ? Center(
            child: Text(
              'No movies available',
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          )
              : SizedBox(
            height: height * 0.36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cachedAdventureMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedAdventureMovies[index]['original_name'] ??
                              cachedAdventureMovies[index]['title'],
                          bannerUrl: cachedAdventureMovies[index]['backdrop_path'] != null
                              ? 'https://image.tmdb.org/t/p/w500' + cachedAdventureMovies[index]['backdrop_path']
                              : '',
                          posterUrl: cachedAdventureMovies[index]['poster_path'] != null
                              ? 'https://image.tmdb.org/t/p/w500' + cachedAdventureMovies[index]['poster_path']
                              : '',
                          description: cachedAdventureMovies[index]['overview'] ?? 'No description available',
                          vote: cachedAdventureMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedAdventureMovies[index]['release_date'] ?? 'Unknown',
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
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedAdventureMovies[index]['poster_path']),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025),
                        Text(
                          cachedAdventureMovies[index]['original_name'] ??
                              cachedAdventureMovies[index]['title'],
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
          ),
        ],
      ),
    );
  }
}
