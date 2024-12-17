import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiTvShows extends StatefulWidget {
  const HindiTvShows({super.key, required this.hindiTvShow});
  final List hindiTvShow;

  @override
  State<HindiTvShows> createState() => _HindiTvShowsState();
}

class _HindiTvShowsState extends State<HindiTvShows> {
  late Box seriesTv;
  List cachedTvShow = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget Tv Show: ${widget.hindiTvShow.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesTv = await Hive.openBox('TvBox');
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
    final cachedData = seriesTv.get('hindiTvShows');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Tv series : ${cachedData.length}");
      setState(() {
        cachedTvShow = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Tv Series.");
      setState(() {
        cachedTvShow = widget.hindiTvShow;
      });
      seriesTv.put('hindiTvShows', widget.hindiTvShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedTvShow.length}");

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
            'Tv Shows',
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
              itemCount: cachedTvShow.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedTvShow[index]['original_name'] != null? cachedTvShow[index]['original_name'] : 'Loading',
                          bannerUrl: cachedTvShow[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTvShow[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedTvShow[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTvShow[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedTvShow[index]['overview'] ?? 'No description available',
                          vote: cachedTvShow[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedTvShow[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedTvShow[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedTvShow[index]['original_name'] != null? cachedTvShow[index]['original_name'] : 'Loading',
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
