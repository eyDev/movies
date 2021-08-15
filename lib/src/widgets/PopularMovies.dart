import 'package:eydev_movies/src/models/MovieModel.dart';
import 'package:eydev_movies/src/pages/MovieDetail.dart';
import 'package:flutter/material.dart';

class PopularMovies extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  PopularMovies({required this.movies, required this.nextPage});
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size.height - 35;
    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });
    return Container(
      height: _screenSize * 0.28,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, i) => _card(context, movies[i]),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-poster';
    final card = Container(
      width: 90,
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(movie.posterPath),
                fit: BoxFit.cover,
                height: 135,
                width: 90,
              ),
            ),
          ),
          Text(
            movie.title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieDetail(movie: movie)),
      ),
    );
  }
}
