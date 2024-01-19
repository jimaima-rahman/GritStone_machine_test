import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_gritstone/model/movie_entity.dart';
import 'package:machine_test_gritstone/model/treanding_model.dart';
import 'package:machine_test_gritstone/services/api_services.dart';

final apiFutureProvider = FutureProvider<List<MovieEntity>>((ref) async {
  return await ref.watch(apiprovider).getTrending();
});

final searchMovieProvider =
    FutureProviderFamily<TrendingMovies?, String>((ref, query) async {
  return await ref.watch(apiprovider).getSearch(query);
});

final searchResultProvider = StateProvider<List<Result>?>((ref) {
  return null;
});
