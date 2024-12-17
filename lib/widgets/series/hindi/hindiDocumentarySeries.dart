import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiDocSeries extends StatefulWidget {
  const HindiDocSeries({super.key, required this.hindiDocumentarySeries});
  final List hindiDocumentarySeries;

  @override
  State<HindiDocSeries> createState() => _HindiDocSeriesState();
}

class _HindiDocSeriesState extends State<HindiDocSeries> {
  late Box seriesDocumentaryBox;
  List cachedDocumentarySeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget Documentary Series: ${widget.hindiDocumentarySeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesDocumentaryBox = await Hive.openBox('DocumentarySeriesBox');
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
    final cachedData = seriesDocumentaryBox.get('hindiDocumentarySeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in action: ${cachedData.length}");
      setState(() {
        cachedDocumentarySeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Doc Series.");
      setState(() {
        cachedDocumentarySeries = widget.hindiDocumentarySeries;
      });
      seriesDocumentaryBox.put('hindiDocumentarySeries', widget.hindiDocumentarySeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedDocumentarySeries.length}");

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
            'Documentary Series',
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
              itemCount: cachedDocumentarySeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedDocumentarySeries[index]['original_name'] != null? cachedDocumentarySeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedDocumentarySeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedDocumentarySeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedDocumentarySeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedDocumentarySeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedDocumentarySeries[index]['overview'] ?? 'No description available',
                          vote: cachedDocumentarySeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedDocumentarySeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedDocumentarySeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedDocumentarySeries[index]['original_name'] != null? cachedDocumentarySeries[index]['original_name'] : 'Loading',
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
