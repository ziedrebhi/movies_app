import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _searchQuery = "";
  List<Movie> _top5Movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    final String apiKey =
        '9a72cc7c15556a22f583079f352620df'; // Replace with your API key
    final String url = _searchQuery.isEmpty
        ? 'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'
        : 'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$_searchQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Movie> loadedMovies = [];

      for (var movieJson in data['results']) {
        loadedMovies.add(Movie.fromJson(movieJson));
      }

      setState(() {
        _movies = loadedMovies;
        _top5Movies =
            loadedMovies.take(5).toList(); // Get top 5 movies for the carousel
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Icon(Icons.movie, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for movies...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: _onSearchChanged,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _movies.isEmpty
              ? Center(
                  child: Text(
                    'No movies found.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              : Column(
                  children: [
                    // Carousel Slider for Top 5 Movies
                    _top5Movies.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                              height: 400,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                              aspectRatio: 16 / 9,
                              initialPage: 0,
                            ),
                            items: _top5Movies.map((movie) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailScreen(movie: movie),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 10.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 6.0,
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : SizedBox.shrink(),

                    // Movie List (Remaining Movies)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _movies.length,
                          itemBuilder: (ctx, index) {
                            final movie = _movies[index];
                            return MovieCard(movie: movie);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 -
                  16, // half screen width minus padding
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis, // Truncate long titles
                  ),
                  Text(
                    'Release Date: ${movie.releaseDate}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis, // Truncate long text
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
