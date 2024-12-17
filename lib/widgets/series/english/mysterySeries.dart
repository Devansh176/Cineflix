import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MysterySeries extends StatefulWidget {
  const MysterySeries({super.key, required this.mysterySeries});
  final List mysterySeries;

  @override
  State<MysterySeries> createState() => _MysterySeriesState();
}

class _MysterySeriesState extends State<MysterySeries> {
  late Box seriesMysteryBox;
  List cachedMysterySeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget mysteryMovies: ${widget.mysterySeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesMysteryBox = await Hive.openBox('MysterySeriesBox');
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
    final cachedData = seriesMysteryBox.get('mysterySeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Mystery series : ${cachedData.length}");
      setState(() {
        cachedMysterySeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Mystery Series.");
      setState(() {
        cachedMysterySeries = widget.mysterySeries;
      });
      seriesMysteryBox.put('mysterySeries', widget.mysterySeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedMysterySeries.length}");


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
            'Mystery Series',
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
              itemCount: cachedMysterySeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedMysterySeries[index]['original_name'] != null? cachedMysterySeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedMysterySeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedMysterySeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedMysterySeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedMysterySeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedMysterySeries[index]['overview'] ?? 'No description available',
                          vote: cachedMysterySeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedMysterySeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedMysterySeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedMysterySeries[index]['original_name'] != null? cachedMysterySeries[index]['original_name'] : 'Loading',
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
