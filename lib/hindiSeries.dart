import 'package:cineflix/widgets/series/hindi/hindiActionSeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiAnimationSeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiComedySeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiDocumentarySeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiDramaSeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiFamilySeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiMysterySeries.dart';
import 'package:cineflix/widgets/series/hindi/hindiRealityShow.dart';
import 'package:cineflix/widgets/series/hindi/hindiTalkShow.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_api/tmdb_api.dart';

class HindiSeries extends StatefulWidget {
  const HindiSeries({super.key});

  @override
  State<HindiSeries> createState() => _HindiSeriesState();
}

class _HindiSeriesState extends State<HindiSeries> {
  late Box hindiSeriesBox;

  Map<String, List> hindiSeriesData = {
    'hindiActionSeries': [],
    'hindiAnimationSeries': [],
    'hindiComedySeries': [],
    'hindiDocumentarySeries': [],
    'hindiMysterySeries': [],
    'hindiDramaSeries': [],
    'hindiFamilySeries': [],
    'hindiTalkSeries': [],
    'hindiRealitySeries': []
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
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    hindiSeriesBox = await Hive.openBox('HindiSeriesCache');
  }

  Future<void> loadSeries() async {
    try {
      final categories = {
        'hindiActionSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10759', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiAnimationSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '16', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiComedySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '35', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiRomanceSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10749', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiDocumentarySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '99', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiWesternSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '37', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiMysterySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '9648', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiDramaSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '18', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiFamilySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10751', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiTalkSeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10767', withOrginalLanguage: 'hi', language: 'hi-IN'),
        'hindiRealitySeries': () => tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: '10764', withOrginalLanguage: 'hi', language: 'hi-IN'),
      };

      for (var category in categories.keys) {
        final cachedData = hindiSeriesBox.get(category);
        if (cachedData != null && cachedData.isNotEmpty) {
          hindiSeriesData[category] = cachedData;
        } else {
          final response = await categories[category]!();
          final results = response['results'];
          hindiSeriesData[category] = results;
          await hindiSeriesBox.put(category, results);
        }
      }

      setState(() {});
    } catch (e) {
      print("Error loading series: $e");
    }
  }

  @override
  void dispose() {
    hindiSeriesBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HindiActionSeries(hindiActionSeries: hindiSeriesData['hindiActionSeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiAnimationSeries(hindiAnimationSeries: hindiSeriesData['hindiAnimationSeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiComedySeries(hindiComedySeries: hindiSeriesData['hindiComedySeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiDocumentarySeries(hindiDocumentarySeries: hindiSeriesData['hindiDocumentarySeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiMysterySeries(hindiMysterySeries: hindiSeriesData['hindiMysterySeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiDramaSeries(hindiDramaSeries: hindiSeriesData['hindiDramaSeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiFamilySeries(hindiFamilySeries: hindiSeriesData['hindiFamilySeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiTalkShow(hindiTalkShow: hindiSeriesData['hindiTalkSeries']!),
          ),
          SliverToBoxAdapter(
            child: HindiRealityShow(hindiRealityShow: hindiSeriesData['hindiRealitySeries']!),
          ),
        ],
      ),
    );
  }
}
