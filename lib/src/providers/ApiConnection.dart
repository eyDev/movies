import 'dart:async';
import 'dart:convert';

import 'package:eydev_movies/src/models/ActorModel.dart';
import 'package:eydev_movies/src/models/MovieModel.dart';
import 'package:eydev_movies/src/models/VideoModel.dart';
import 'package:http/http.dart' as http;

class ApiConnection {
  static final ApiConnection _instancia = new ApiConnection._();
  factory ApiConnection() {
    return _instancia;
  }
  ApiConnection._();

  final String _apikey = 'YOUR-THEMOVIEDB-SECRET-API';
  final String _baseUrl = 'api.themoviedb.org';
  int _popularesPage = 0;

  List<Movie> _populars = [];
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController.close();
  }

  Future _getData(String endpoint, {String query = '', int page = -1}) async {
    Map<String, dynamic> parameters = <String, dynamic>{
      'api_key': _apikey,
      'language': 'es-ES',
    };
    if (query != '') parameters['query'] = query;
    if (page != -1) parameters['page'] = _popularesPage.toString();
    final Uri url = Uri.https(_baseUrl, endpoint, parameters);
    final http.Response resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    return decodedData;
  }

  Future<List<Movie>> getCurrentMovies() async {
    final decodedData = await _getData('/3/movie/now_playing');
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Actor>> getActors(String peliId) async {
    final decodedData = await _getData('/3/movie/$peliId/credits');
    final actors = new Actors.fromJsonList(decodedData['cast']);
    return actors.items;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final decodedData = await _getData('/3/search/movie', query: query);
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Video>> getVideos(String peliId) async {
    final decodedData = await _getData('/3/movie/$peliId/videos');
    print(decodedData);
    final videos = new Videos.fromJsonList(decodedData['results']);
    return videos.items;
  }

  Future<List<Movie>> getPopulars() async {
    _popularesPage++;
    final decodedData = await _getData('/3/movie/popular', page: _popularesPage);
    final movies = new Movies.fromJsonList(decodedData['results']);
    _populars.addAll(movies.items);
    popularsSink(_populars);
    return movies.items;
  }
}
