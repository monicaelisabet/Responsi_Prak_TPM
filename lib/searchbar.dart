import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuSearchScreen extends StatefulWidget {
  @override
  _MenuSearchScreenState createState() => _MenuSearchScreenState();
}

class _MenuSearchScreenState extends State<MenuSearchScreen> {
  List<dynamic> searchResults = [];
  String searchQuery = '';

  void searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('https://www.omdbapi.com/?s=$query&apikey=4935f984'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data['Search'] ?? [];
      });
    } else {
      // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onSubmitted: (value) {
                searchMovies(value);
              },
              decoration: InputDecoration(
                labelText: 'Search movies',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = searchResults[index];
                final title = movie['Title'];
                final year = movie['Year'];
                final poster = movie['Poster'];

                return ListTile(
                  leading: Image.network(poster),
                  title: Text(title),
                  subtitle: Text(year),
                  onTap: () {
                    _showDetailDialog(movie);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(dynamic movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final title = movie['Title'];
        final genre = movie['Genre'];
        final dateReleased = movie['Released'];
        final director = movie['Director'];
        final actor = movie['Actors'];
        final plot = movie['Plot'];

        return AlertDialog(
          title: Text(title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Genre: $genre'),
              SizedBox(height: 8.0),
              Text('Date Released: $dateReleased'),
              SizedBox(height: 8.0),
              Text('Director: $director'),
              SizedBox(height: 8.0),
              Text('Actor: $actor'),
              SizedBox(height: 8.0),
              Text('Plot: $plot'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
