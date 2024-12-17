import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RomanceSeries extends StatefulWidget {
  const RomanceSeries({super.key, required this.romanceSeries});
  final List romanceSeries;

  @override
  State<RomanceSeries> createState() => _RomanceSeriesState();
}

class _RomanceSeriesState extends State<RomanceSeries> {
  late Box seriesRomanceBox;
  List cachedRomanceSeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget romanceSeries: ${widget.romanceSeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesRomanceBox = await Hive.openBox('RomanceSeriesBox');
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
    final cachedData = seriesRomanceBox.get('romanceSeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Romance series : ${cachedData.length}");
      setState(() {
        cachedRomanceSeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Romance Series.");
      setState(() {
        cachedRomanceSeries = widget.romanceSeries;
      });
      seriesRomanceBox.put('romanceSeries', widget.romanceSeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedRomanceSeries.length}");
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
            'Romance Series',
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
              itemCount: cachedRomanceSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedRomanceSeries[index]['original_name'] != null? cachedRomanceSeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedRomanceSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedRomanceSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedRomanceSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedRomanceSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedRomanceSeries[index]['overview'] ?? 'No description available',
                          vote: cachedRomanceSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedRomanceSeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedRomanceSeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedRomanceSeries[index]['original_name'] != null? cachedRomanceSeries[index]['original_name'] : 'Loading',
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
