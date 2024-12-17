import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Comedy extends StatefulWidget {
  const Comedy({super.key, required this.comedySeries});
  final List comedySeries;

  @override
  State<Comedy> createState() => _ComedyState();
}

class _ComedyState extends State<Comedy> {
  late Box seriesComedyBox;
  List cachedComedySeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget ComedySeries: ${widget.comedySeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesComedyBox = await Hive.openBox('ComedySeriesBox');
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
    final cachedData = seriesComedyBox.get('comedySeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in comedySeries : ${cachedData.length}");
      setState(() {
        cachedComedySeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Comedy Series.");
      setState(() {
        cachedComedySeries = widget.comedySeries;
      });
      seriesComedyBox.put('comedySeries', widget.comedySeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedComedySeries.length}");

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
            'Comedy Series',
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
              itemCount: cachedComedySeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedComedySeries[index]['original_name'] != null? cachedComedySeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedComedySeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedComedySeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedComedySeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedComedySeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedComedySeries[index]['overview'] ?? 'No description available',
                          vote: cachedComedySeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedComedySeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedComedySeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedComedySeries[index]['original_name'] != null? cachedComedySeries[index]['original_name'] : 'Loading',
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
