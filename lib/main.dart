import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/animation_movie.dart';
import 'services/api_service.dart';

void main() {
  runApp(GhibliMovieApp());
}

class GhibliMovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghibli Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<AnimationMovie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Studio Ghibli Movies'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<AnimationMovie>>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load movies'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No movies found'));
              }

              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(movie.image, width: 50),
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text('Director: ${movie.director}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final AnimationMovie movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Stack(
        children: [
          // Fullscreen Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover, // Ensures the image covers the whole screen
            ),
          ),

          // Movie Details with scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(movie.movieBanner),
                ),
                SizedBox(height: 20),

                // Movie Description
                Text(
                  movie.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Movie Information Section
                Divider(color: Colors.white),
                Text(
                  'Director: ${movie.director}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Producer: ${movie.producer}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Release Date: ${movie.releaseDate}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Running Time: ${movie.runningTime} minutes',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Rotten Tomatoes Score: ${movie.rtScore}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
