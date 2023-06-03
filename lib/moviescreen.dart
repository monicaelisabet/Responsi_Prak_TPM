import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<dynamic> movies = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchMovies(String searchTerm) async {
    final apiKey = '4935f984';
    final url = 'https://www.omdbapi.com/?apikey=$apiKey&s=$searchTerm';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == "True") {
          setState(() {
            movies = data['Search'];
          });
        } else {
          setState(() {
            movies = [];
          });
        }
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  void logout() {
    // Tambahkan logika logout di sini, seperti menghapus token atau data pengguna yang disimpan

    // Navigasikan ke halaman login atau halaman utama aplikasi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(), // Ganti dengan halaman login atau halaman utama aplikasi
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for a movie',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchMovies(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(imdbID: movie['imdbID']),
                      ),
                    );
                  },
                  leading: Image.network(
                    movie['Poster'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(movie['Title']),
                  subtitle: Text(movie['Year']),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

class MovieDetail extends StatefulWidget {
  final String imdbID;

  MovieDetail({required this.imdbID});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Map<String, dynamic>? movieDetails;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final apiKey = '4935f984';
    final url = 'https://www.omdbapi.com/?apikey=$apiKey&i=${widget.imdbID}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          movieDetails = data;
        });
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail'),
      ),
      body: movieDetails != null
          ? Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieDetails!['Title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Year: ${movieDetails!['Year']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Director: ${movieDetails!['Director']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Plot: ${movieDetails!['Plot']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
