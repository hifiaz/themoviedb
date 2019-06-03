import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromMap(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toMap());

class Favorite {
  String title;
  int id;
  String poster;
  String overview;
  double vote;

  Favorite({
    this.title,
    this.id,
    this.poster,
    this.overview,
    this.vote,
  });

  factory Favorite.fromMap(Map<String, dynamic> json) => new Favorite(
        title: json["title"],
        id: json["id"],
        poster: json["poster"],
        overview: json["overview"],
        vote: json["vote"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "id": id,
        "poster": poster,
        "overview": overview,
        "vote": vote,
      };
}
