import 'package:cineflix/widgets/series/english/actionSeries.dart';
import 'package:cineflix/widgets/series/english/animationSeries.dart';
import 'package:cineflix/widgets/series/english/comedySeries.dart';
import 'package:cineflix/widgets/series/english/documentarySeries.dart';
import 'package:cineflix/widgets/series/english/dramaSeries.dart';
import 'package:cineflix/widgets/series/english/familySeries.dart';
import 'package:cineflix/widgets/series/english/mysterySeries.dart';
import 'package:cineflix/widgets/series/english/realityShow.dart';
import 'package:cineflix/widgets/series/english/romanceSeries.dart';
import 'package:cineflix/widgets/series/english/talkShow.dart';
import 'package:cineflix/widgets/series/english/topRatedSeries.dart';
import 'package:cineflix/widgets/series/english/tv.dart';
import 'package:cineflix/widgets/series/english/western.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_api/tmdb_api.dart';

class EngSeries extends StatefulWidget {
  const EngSeries({super.key});

  @override
  State<EngSeries> createState() => _EngSeriesState();
}

class _EngSeriesState extends State<EngSeries> {
  late Box englishSeriesBox;

  Map<String, List> englishSeriesData = {
    'tvShows': [],
    'topRatedSeries': [],
    'actionSeries': [],
    'animationSeries': [],
    'comedySeries': [],
    'romanceSeries': [],
    'documentarySeries': [],
    'westernSeries': [],
    'mysterySeries': [],
    'dramaSeries': [],
    'familySeries': [],
    'talkSeries': [],
    'realitySeries': [],
  };

  final String apiKey = 'caab8223e29b6c77c16940d6e2ccfa5e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWFiODIyM2UyOWI2Yzc3YzE2OTQwZDZlMmNjZmE1ZSIsIm5iZiI6MTczMjgwMDM1Mi43OTc0NTIyLCJzdWIiOiI2NzQ4NmQ2MjJlZDM5YTNhZjE3MWUxYjgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.14l3iY-IjTx0kJwnE17stnAvxo58nsENZD1-kIoWY7I';

  late TMDB tmdbWithCustomLogs;

  @override
  void initState() {
    super.initState();
    initializeHive().then((_) => loadSeries());
    tmdbWithCustomLogs = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: ConfigLogger(showErrorLogs: true, showLogs: true),
    );
    loadSeries();
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    englishSeriesBox = await Hive.openBox('EnglishSeriesCache');
  }

  Future<void> loadSeries() async {
    try {
      final categories = {
        'tvShows': () => tmdbWithCustomLogs.v3.tv.getPopular(language: 'en-US'),
        'topRatedSeries': () => tmdbWithCustomLogs.v3.tv.getTopRated(language: 'en-US'),
        'actionSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10759', language: 'en-US'),
        'animationSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '16', language: 'en-US'),
        'comedySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '35', language: 'en-US'),
        'romanceSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10749', language: 'en-US'),
        'documentarySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '99', language: 'en-US'),
        'westernSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '37', language: 'en-US'),
        'mysterySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '9648', language: 'en-US'),
        'dramaSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', language: 'en-US'),
        'familySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10751', language: 'en-US'),
        'talkSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10767', language: 'en-US'),
        'realitySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10764', language: 'en-US'),
      };

      for (var category in categories.keys) {
        final cachedData = englishSeriesBox.get(category);
        if (cachedData != null) {
          englishSeriesData[category] = cachedData;
        } else {
          final response = await categories[category]!();
          final results = response['results'];
          englishSeriesData[category] = results;
          await englishSeriesBox.put(category, results);
        }
      }
      setState(() {});
    } catch (e) {
      print("Error loading series: $e");
    }
  }

  @override
  void dispose() {
    englishSeriesBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TvShows(tv: englishSeriesData['tvShows']!),
          ),
          SliverToBoxAdapter(
            child: TopRatedSeries(topRatedSeries: englishSeriesData['topRatedSeries']!),
          ),
          SliverToBoxAdapter(
            child: ActionSeries(actionSeries: englishSeriesData['actionSeries']!),
          ),
          SliverToBoxAdapter(
            child: AnimationSeries(animationSeries: englishSeriesData['animationSeries']!),
          ),
          SliverToBoxAdapter(
            child: Comedy(comedySeries: englishSeriesData['comedySeries']!),
          ),
          SliverToBoxAdapter(
            child: RomanceSeries(romanceSeries: englishSeriesData['romanceSeries']!),
          ),
          SliverToBoxAdapter(
            child: DocSeries(documentarySeries: englishSeriesData['documentarySeries']!),
          ),
          SliverToBoxAdapter(
            child: WesternSeries(westernSeries: englishSeriesData['westernSeries']!),
          ),
          SliverToBoxAdapter(
            child: MysterySeries(mysterySeries: englishSeriesData['mysterySeries']!),
          ),
          SliverToBoxAdapter(
            child: Drama(dramaSeries: englishSeriesData['dramaSeries']!),
          ),
          SliverToBoxAdapter(
            child: FamilyShow(familyShow: englishSeriesData['familySeries']!),
          ),
          SliverToBoxAdapter(
            child: Talk(talkSeries: englishSeriesData['talkSeries']!),
          ),
          SliverToBoxAdapter(
            child: Reality(realityShow: englishSeriesData['realitySeries']!),
          ),
        ],
      ),
    );
  }
}
