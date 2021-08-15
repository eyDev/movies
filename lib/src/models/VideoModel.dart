class Videos {
  List<Video> items = [];
  Videos.fromJsonList(List<dynamic> jsonList) {
    jsonList.forEach((item) {
      final actor = Video.fromJsonMap(item);
      items.add(actor);
    });
  }
}

class Video {
  String id;
  String key;

  Video({
    required this.id,
    required this.key,
  });

  factory Video.fromJsonMap(Map<String, dynamic> json) => new Video(
        id: json['id'],
        key: json['key'],
      );
}
