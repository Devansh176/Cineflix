import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiDramaSeries extends StatefulWidget {
  const HindiDramaSeries({super.key, required this.hindiDramaSeries});
  final List hindiDramaSeries;

  @override
  State<HindiDramaSeries> createState() => _HindiDramaSeriesState();
}

class _HindiDramaSeriesState extends State<HindiDramaSeries> {
  late Box seriesDramaBox;
  List cachedDramaSeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget dramaMovies: ${widget.hindiDramaSeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesDramaBox = await Hive.openBox('DramaSeriesBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        loadSeries();
      }
    }
  }

  void loadSeries() {
    final cachedData = seriesDramaBox.get('hindiDramaSeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in drama show : ${cachedData.length}");
      setState(() {
        cachedDramaSeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Drama Series.");
      setState(() {
        cachedDramaSeries = widget.hindiDramaSeries;
      });
      seriesDramaBox.put('hindiDramaSeries', widget.hindiDramaSeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedDramaSeries.length}");

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
            'Drama Series',
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
              itemCount: cachedDramaSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedDramaSeries[index]['original_name'] != null? cachedDramaSeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedDramaSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedDramaSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedDramaSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedDramaSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedDramaSeries[index]['overview'] ?? 'No description available',
                          vote: cachedDramaSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedDramaSeries[index]['first_air_date'] ?? 'Unknown',
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
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedDramaSeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedDramaSeries[index]['original_name'] != null? cachedDramaSeries[index]['original_name'] : 'Loading',
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
