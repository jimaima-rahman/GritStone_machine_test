import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_gritstone/model/movie_entity.dart';
import 'package:machine_test_gritstone/model/treanding_model.dart';
import 'package:machine_test_gritstone/services/objectbox.dart';
import 'package:path_provider/path_provider.dart';

class Apiservices {
  final Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': '85c769a17d7385f87d8114d0a5c0d7a1'}));

  Future<List<MovieEntity>> getTrending() async {
    try {
      Response response = await dio.get('/trending/movie/day');
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        var jsonResponse = json.encode(response.data);
        final movies = trendingMoviesFromJson(jsonResponse);

        ObjectBox.instance.movieBox.removeAll();
        ObjectBox.instance.movieBox.putMany([
          for (final movie in movies.results)
            MovieEntity()
              ..imageUrl = movie.posterPath
              ..title = movie.title
        ]);
      }
    } catch (e) {
      print("an error occured on getTrending :$e");
    }
    return ObjectBox.instance.movieBox.getAll();
  }

  Future<TrendingMovies?> getSearch(String query) async {
    try {
      Response response = await dio.get("/search/movie?query=$query");
      if (response.statusCode == 200) {
        var jsonResponse = json.encode(response.data);
        return trendingMoviesFromJson(jsonResponse);
      }
    } on DioException catch (e) {
      print("an error occured on getTrending :$e");
      return null;
    }
    return null;
  }

  Future<String?> downloadImage(MovieEntity movie) async {
    if (movie.imagePath != null) {
      return movie.imagePath;
    }

    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      final newFolder = await Directory('${appDocDirectory.path}/images')
          .create(recursive: true);
      final downloadPath = '${newFolder.path}/${movie.imageUrl}';
      Response response = await Dio(BaseOptions(queryParameters: {
        'api_key': '85c769a17d7385f87d8114d0a5c0d7a1'
      })).download(
          "https://image.tmdb.org/t/p/w500/${movie.imageUrl}", downloadPath);
      if (response.statusCode == 200) {
        movie.imagePath = downloadPath;
        ObjectBox.instance.movieBox.put(movie);

        return downloadPath;
      }
    } on DioException catch (e) {
      print("an error occured on download image :$e");
      return null;
    }
    return null;
  }
}

final apiprovider = Provider<Apiservices>((ref) {
  return Apiservices();
});
