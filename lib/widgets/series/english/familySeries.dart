import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FamilyShow extends StatefulWidget {
  const FamilyShow({super.key, required this.familyShow});
  final List familyShow;

  @override
  State<FamilyShow> createState() => _FamilyShowState();
}

class _FamilyShowState extends State<FamilyShow> {
  late Box seriesFamilyBox;
  List cachedFamilySeries = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget FamilySeries: ${widget.familyShow.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesFamilyBox = await Hive.openBox('FamilySeriesBox');
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
    final cachedData = seriesFamilyBox.get('familySeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Family series : ${cachedData.length}");
      setState(() {
        cachedFamilySeries = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Family Series.");
      setState(() {
        cachedFamilySeries = widget.familyShow;
      });
      seriesFamilyBox.put('familySeries', widget.familyShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedFamilySeries.length}");


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
            'Family Series',
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
              itemCount: cachedFamilySeries.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedFamilySeries[index]['original_name'] != null? cachedFamilySeries[index]['original_name'] : 'Loading',
                          bannerUrl: cachedFamilySeries[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedFamilySeries[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedFamilySeries[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedFamilySeries[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedFamilySeries[index]['overview'] ?? 'No description available',
                          vote: cachedFamilySeries[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedFamilySeries[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedFamilySeries[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedFamilySeries[index]['original_name'] != null? cachedFamilySeries[index]['original_name'] : 'Loading',
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
