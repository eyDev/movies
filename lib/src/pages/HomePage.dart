import 'package:eydev_movies/src/providers/ApiConnection.dart';
import 'package:eydev_movies/src/search/SearchDelegate.dart';
import 'package:eydev_movies/src/widgets/CurrentMovies.dart';
import 'package:eydev_movies/src/widgets/PopularMovies.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final ApiConnection api = ApiConnection();
  @override
  Widget build(BuildContext context) {
    api.getPopulars();
    return Scaffold(
      appBar: _appbar(context),
      body: _body(context),
    );
  }

  AppBar _appbar(BuildContext context) => AppBar(
        title: Text(
          'eydev - Películas',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () => showSearch(context: context, delegate: DataSearch()),
          ),
        ],
      );

  Widget _body(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cardSwiper(),
            _popularCards(context),
          ],
        ),
      );

  Widget _cardSwiper() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            'En cines',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: api.getCurrentMovies(),
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                CurrentMovies(movies: snapshot.hasData ? snapshot.data : null),
          ),
        ],
      ),
    );
  }

  Widget _popularCards(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Películas Populares',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          StreamBuilder(
            stream: api.popularsStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return PopularMovies(
                  movies: snapshot.data,
                  nextPage: api.getPopulars,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
