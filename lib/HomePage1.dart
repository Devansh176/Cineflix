import 'package:cineflix/engMovies.dart';
import 'package:cineflix/engSeries.dart';
import 'package:flutter/material.dart';

class Homepage1 extends StatelessWidget {
  const Homepage1({super.key});

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
            alignment: Alignment.centerLeft,
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
                EngMovies(),
                EngSeries(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
