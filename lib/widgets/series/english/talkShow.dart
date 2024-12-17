import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Talk extends StatefulWidget {
  const Talk({super.key, required this.talkSeries});
  final List talkSeries;

  @override
  State<Talk> createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  late Box seriesTalkBox;
  List cachedTalkShow = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget Talk Show: ${widget.talkSeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesTalkBox = await Hive.openBox('TalkShowBox');
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
    final cachedData = seriesTalkBox.get('talkSeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in Family series : ${cachedData.length}");
      setState(() {
        cachedTalkShow = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed Talk Show.");
      setState(() {
        cachedTalkShow = widget.talkSeries;
      });
      seriesTalkBox.put('talkSeries', widget.talkSeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedTalkShow.length}");

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
            'Talk Series',
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
              itemCount: cachedTalkShow.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedTalkShow[index]['original_name'] != null? cachedTalkShow[index]['original_name'] : 'Loading',
                          bannerUrl: cachedTalkShow[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTalkShow[index]['backdrop_path'] : cachedTalkShow[index]['poster_path'],
                          posterUrl: cachedTalkShow[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTalkShow[index]['poster_path'] : cachedTalkShow[index]['backdrop_path'],
                          description: cachedTalkShow[index]['overview'] ?? 'No description available',
                          vote: cachedTalkShow[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedTalkShow[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedTalkShow[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedTalkShow[index]['original_name'] != null? cachedTalkShow[index]['original_name'] : 'Loading',
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
