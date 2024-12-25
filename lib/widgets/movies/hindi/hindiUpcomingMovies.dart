import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HindiUpcomingMovies extends StatefulWidget {
  const HindiUpcomingMovies({super.key, required this.upcomingHindiMovies});
  final List upcomingHindiMovies;

  @override
  State<HindiUpcomingMovies> createState() => _HindiUpcomingMoviesState();
}

class _HindiUpcomingMoviesState extends State<HindiUpcomingMovies> {
  late Box upcomingBox;
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHiveOnce();
  }

  Future<void> _initializeHiveOnce() async {
    if (!isHiveInitialized) {
      try {
        if (Hive.isBoxOpen('UpcomingMoviesBox')) {
          print("Hive Box is already opened.");
          upcomingBox = Hive.box('UpcomingMoviesBox');
        } else {
          print("Opening Hive Box...");
          upcomingBox = await Hive.openBox('UpcomingMoviesBox');
          print("Hive Box Opened Successfully");
        }
        setState(() {
          isHiveInitialized = true;
        });
      } catch (e) {
        print("Error initializing Hive: $e");
      }
    }
  }

  Future<List> loadMovies() async {
    try {
      if (!isHiveInitialized) {
        await _initializeHiveOnce();
      }

      final cachedData = upcomingBox.get('upcomingHindiMovies');
      final cachedTimestamp = upcomingBox.get('upcomingHindiMoviesTimestamp');

      if (cachedData != null && cachedData.isNotEmpty && cachedTimestamp != null) {
        final currentTime = DateTime.now();
        final cacheTime = DateTime.parse(cachedTimestamp);
        final difference = currentTime.difference(cacheTime).inDays;

        if (difference <= 3) {
          return List.from(cachedData);
        }
      }

      await upcomingBox.put('upcomingHindiMovies', widget.upcomingHindiMovies);
      await upcomingBox.put('upcomingHindiMoviesTimestamp', DateTime.now().toIso8601String());

      return widget.upcomingHindiMovies;
    } catch (e) {
      return [];
    }
  }

  String getValidImageUrl(String? url) {
    return (url != null && url.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w500$url'
        : 'https://via.placeholder.com/300';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    return FutureBuilder<List>(
      future: loadMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Failed to load movies. Please try again.',
                  style: TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No movies available.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final movies = snapshot.data!;
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Container(
          color: themeProvider.getTheme() ? Colors.black : Colors.white,
          padding: EdgeInsets.only(
            top: padding * 0.8,
            left: padding * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Movies',
                style: GoogleFonts.afacad(
                  color: themeProvider.getTheme() ? Colors.amber : Colors.yellow[800],
                  fontSize: fontSize * 1.53,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.39,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Description(
                              name: movies[index]['original_name'] ??
                                  movies[index]['title'],
                              bannerUrl: getValidImageUrl(
                                  movies[index]['backdrop_path']),
                              posterUrl: getValidImageUrl(
                                  movies[index]['poster_path']),
                              description: movies[index]['overview'] ??
                                  'No description available',
                              vote: movies[index]['vote_average']?.toString() ??
                                  'N/A',
                              launch_on:
                              movies[index]['release_date'] ?? 'Unknown',
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: getValidImageUrl(
                                    movies[index]['poster_path']),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(child: Text("")),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            Text(
                              movies[index]['original_name'] ??
                                  movies[index]['title'],
                              style: GoogleFonts.afacad(
                                color: Colors.red,
                                fontSize: fontSize * 0.95,
                                fontWeight: FontWeight.w700,
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
      },
    );
  }
}
