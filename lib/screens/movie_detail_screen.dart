import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<dynamic> _cast = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieCast();
  }

  Future<void> fetchMovieCast() async {
    final String apiKey =
        '9a72cc7c15556a22f583079f352620df'; // Replace with your API key
    final String url =
        'https://api.themoviedb.org/3/movie/${widget.movie.id}/credits?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _cast = data['cast'].take(10).toList(); // Get top 10 billed cast
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load cast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'),
              SizedBox(height: 20),
              Text(
                'Release Date: ${widget.movie.releaseDate}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Overview:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.movie.overview,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Top Billed Cast:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _cast.isEmpty
                      ? Text('No cast information available.')
                      : Container(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _cast.length,
                            itemBuilder: (ctx, index) {
                              final castMember = _cast[index];
                              return CastCard(castMember: castMember);
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class CastCard extends StatelessWidget {
  final dynamic castMember;

  const CastCard({required this.castMember});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${castMember['profile_path'] ?? ''}',
              height: 100,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            castMember['name'] ?? 'Unknown',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            castMember['character'] ?? '',
            style: TextStyle(fontSize: 12, color: Colors.white60),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
