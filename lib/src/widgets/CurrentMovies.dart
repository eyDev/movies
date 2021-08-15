import 'package:card_swiper/card_swiper.dart';
import 'package:eydev_movies/src/models/MovieModel.dart';
import 'package:eydev_movies/src/pages/MovieDetail.dart';
import 'package:flutter/material.dart';

class CurrentMovies extends StatelessWidget {
  final List<Movie>? movies;

  CurrentMovies({this.movies});

  @override
  Widget build(BuildContext context) {
    final cardHeight = (MediaQuery.of(context).size.height * 0.47) - 35;
    if (movies != null) {
      return Swiper(
        itemWidth: (cardHeight * 2) / 3,
        itemHeight: cardHeight,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          movies![index].uniqueId = '${movies![index].id}-tarjeta';
          return Hero(
            tag: movies![index].uniqueId ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieDetail(movie: movies![index])),
                ),
                child: FadeInImage(
                  image: NetworkImage(movies![index].posterPath),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies!.length,
      );
    } else {
      return Swiper(
        itemWidth: (cardHeight * 2) / 3,
        itemHeight: cardHeight,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              image: AssetImage('assets/no-image.jpg'),
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: 3,
      );
    }
  }
}
