import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiWesternSeries extends StatefulWidget {
  const HindiWesternSeries({super.key, required this.hindiWesternSeries});
  final List hindiWesternSeries;

  @override
  State<HindiWesternSeries> createState() => _HindiWesternSeriesState();
}

class _HindiWesternSeriesState extends State<HindiWesternSeries> {
  late Box seriesWestern;
  List cachedWesternSeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget Western Series : ${widget.hindiWesternSeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesWestern = await Hive.openBox('WesternSeriesBox');
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
    final cachedData = seriesWestern.get('hindiWesternSeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Western series : ${cachedData.length}");
      setState(() {
        cachedWesternSeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Western Series.");
      setState(() {
        cachedWesternSeries = widget.hindiWesternSeries;
      });
      seriesWestern.put('hindiWesternSeries', widget.hindiWesternSeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedWesternSeries.length}");

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
            'Western Series',
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
              itemCount: cachedWesternSeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedWesternSeries[index]['original_name'] != null? cachedWesternSeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedWesternSeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedWesternSeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedWesternSeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedWesternSeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedWesternSeries[index]['overview'] ?? 'No description available',
                          vote: cachedWesternSeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedWesternSeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedWesternSeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedWesternSeries[index]['original_name'] != null? cachedWesternSeries[index]['original_name'] : 'Loading',
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
