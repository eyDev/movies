import 'package:eydev_movies/src/pages/MovieDetail.dart';
import 'package:eydev_movies/src/providers/ApiConnection.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  final ApiConnection api = ApiConnection();
  DataSearch()
      : super(
          searchFieldLabel: 'Buscar películas',
          keyboardType: TextInputType.text,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _searchResult();

  @override
  Widget buildSuggestions(BuildContext context) => _searchResult();

  Widget _searchResult() {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: api.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map<Widget>((movie) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.posterPath),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieDetail(movie: movie)),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
