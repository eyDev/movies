class Actors {
  List<Actor> items = [];
  Actors.fromJsonList(List<dynamic> jsonList) {
    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      items.add(actor);
    });
  }
}

class Actor {
  int castId;
  String name;
  String profilePath;

  Actor({
    required this.castId,
    required this.name,
    required this.profilePath,
  });

  factory Actor.fromJsonMap(Map<String, dynamic> json) => new Actor(
        castId: json['cast_id'],
        name: json['name'],
        profilePath: json['profile_path'] == null
            ? 'https://causeofaction.org/wp-content/uploads/2013/09/Not-available.gif'
            : 'https://image.tmdb.org/t/p/w500/${json['profile_path']}',
      );
}
