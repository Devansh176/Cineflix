import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiRealityShow extends StatefulWidget {
  const HindiRealityShow({super.key, required this.hindiRealityShow});
  final List hindiRealityShow;

  @override
  State<HindiRealityShow> createState() => _HindiRealityShowState();
}

class _HindiRealityShowState extends State<HindiRealityShow> {
  late Box seriesRealityBox;
  List cachedRealityShow = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget realityShow: ${widget.hindiRealityShow.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesRealityBox = await Hive.openBox('RealityShowBox');
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
    final cachedData = seriesRealityBox.get('hindiRealitySeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in action: ${cachedData.length}");
      setState(() {
        cachedRealityShow = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed RealityShow.");
      setState(() {
        cachedRealityShow = widget.hindiRealityShow;
      });
      seriesRealityBox.put('hindiRealitySeries', widget.hindiRealityShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedRealityShow.length}");

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
            'Reality Show',
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
              itemCount: cachedRealityShow.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedRealityShow[index]['original_name'] != null? cachedRealityShow[index]['original_name'] : 'Loading',
                          bannerUrl: cachedRealityShow[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedRealityShow[index]['backdrop_path'] : cachedRealityShow[index]['poster_path'],
                          posterUrl: cachedRealityShow[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedRealityShow[index]['poster_path'] : cachedRealityShow[index]['backdrop_path'],
                          description: cachedRealityShow[index]['overview'] ?? 'No description available',
                          vote: cachedRealityShow[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedRealityShow[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedRealityShow[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedRealityShow[index]['original_name'] != null? cachedRealityShow[index]['original_name'] : 'Loading',
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
