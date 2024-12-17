import 'package:cineflix/hindiMovies.dart';
import 'package:cineflix/hindiSeries.dart';
import 'package:flutter/material.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: width * 0.53,
              color: Colors.black,
              child: TabBar(
                dividerColor: Colors.purple,
                labelColor: Colors.purpleAccent,
                indicatorColor: Colors.purpleAccent,
                indicatorWeight: 3,
                unselectedLabelColor: Colors.purple,
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'Series'),  
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                HindiMovies(),
                HindiSeries(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
