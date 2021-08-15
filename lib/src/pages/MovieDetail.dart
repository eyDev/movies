import 'package:eydev_movies/src/models/ActorModel.dart';
import 'package:eydev_movies/src/models/MovieModel.dart';
import 'package:eydev_movies/src/models/VideoModel.dart';
import 'package:eydev_movies/src/providers/ApiConnection.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);
  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final ApiConnection api = ApiConnection();
  @override
  Widget build(BuildContext context) {
    final Movie movie = widget.movie;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appbar(movie),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitle(context, movie),
            _description(movie),
            SizedBox(height: 10),
            _videos(movie),
            _actors(movie),
          ]))
        ],
      ),
    );
  }

  Widget _appbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.black,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          child: Text(
            movie.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(movie.backdropPath),
          placeholder: AssetImage('assets/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId ?? '',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.posterPath),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star),
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                'Géneros: ${movie.genreIds.map((e) => movie.genders[e]).join(', ')}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Fecha de estreno: ${movie.releaseDate}',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          Text(
            movie.overview,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _videos(Movie movie) {
    return FutureBuilder(
      future: api.getVideos(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<Video> videos = snapshot.data;
          return Column(
            children: new List.generate(videos.length, (index) => _videoCard(context, videos[index], index)).toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget _videoCard(BuildContext context, Video video, int index) {
    return ElevatedButton(
      onPressed: () => launchURL(video.key),
      child: Text('Ver trailer ${index + 1}'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 40),
        ),
      ),
    );
  }

  Widget _actors(Movie movie) {
    return FutureBuilder(
      future: api.getActors(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Actor> actores = snapshot.data;
          return SizedBox(
            height: 200.0,
            child: PageView.builder(
              pageSnapping: false,
              controller: PageController(viewportFraction: 0.3, initialPage: 1),
              itemCount: actores.length,
              itemBuilder: (context, i) => _actorCard(actores[i]),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      margin: new EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.profilePath),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  launchURL(String id) async {
    final youtubeUrl = 'https://www.youtube.com/watch?v=$id';
    await launch(youtubeUrl);
  }
}
