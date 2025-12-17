import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';
import 'edit.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // Make list variable to accommodate all data from database
  List _get = [];
  
  // Make different color to different card
  final _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  void initState() {
    super.initState();
    // In first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
        // You have to take the ip address of your computer.
        // Because using localhost will cause an error
        "http://192.168.187.95/latihan/note_app/list.php"
      ));
      
      // If response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Entry data to variable list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      // If not equal to 0 show data
      // Else show text "no data available"
      body: _get.length != 0
        // We use masonry grid to make masonry card style
        ? MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: _get.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    // Routing into edit page
                    // We pass the id note
                    MaterialPageRoute(
                      builder: (context) => Edit(
                        id: _get[index]['id'],
                      ),
                    ),
                  );
                },
                child: Card(
                  // Make random color to every card
                  color: _lightColors[index % _lightColors.length],
                  child: Container(
                    // Make 2 different height
                    constraints: BoxConstraints(
                      minHeight: (index % 2 + 1) * 85
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_get[index]['date']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${_get[index]['title']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              "No Data Available",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            // Routing into add page
            MaterialPageRoute(builder: (context) => Add()),
          );
        },
      ),
    );
  }
}