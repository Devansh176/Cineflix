import 'package:cineflix/provider/historyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookedHistory extends StatelessWidget {
  const BookedHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final padding = width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: Colors.black,
      ),
      body: Consumer<HistoryProvider>(
        builder: (ctx, historyProvider, __) {
          var allData = historyProvider.getData();
          print("Booking history: $allData");
          return allData.isNotEmpty
              ? Container(
            margin: EdgeInsets.all(padding * 0.2),
            child: ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) {
                var item = allData[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: padding * 0.1),
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: padding * 0.5,
                          vertical: padding * 0.3,
                        ),
                        title: Text(
                          item['title'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${item['date'] ?? 'N/A'}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Time: ${item['time'] ?? 'N/A'}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Status: ${item['status'] ?? 'N/A'}",
                              style: TextStyle(
                                color: item['status'] == 'Success'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              "Cost: ₹${item['cost'] ?? '0'}",
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.movie,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No shows booked yet...!!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
