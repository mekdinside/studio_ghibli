// lib/api_service.dart
import 'package:http/http.dart' as http;
import '../models/animation_movie.dart';

class ApiService {
  static const String baseUrl = 'https://ghibliapi.vercel.app/films';

  Future<List<AnimationMovie>> fetchMovies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return animationMovieFromJson(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
