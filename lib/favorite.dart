import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteMovies = [];

  void addToFavorites(String movieTitle) {
    setState(() {
      favoriteMovies.add(movieTitle);
    });
  }

  void removeFromFavorites(String movieTitle) {
    setState(() {
      favoriteMovies.remove(movieTitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (BuildContext context, int index) {
          final movieTitle = favoriteMovies[index];
          return ListTile(
            title: Text(movieTitle),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeFromFavorites(movieTitle);
              },
            ),
          );
        },
      ),
    );
  }
}
