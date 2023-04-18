// Detail MODEL
import 'dart:convert';

DetailMovieModel detailMovieFromJson(String str) =>
    DetailMovieModel.fromJson(json.decode(str));

class DetailMovieModel {
  DetailMovieModel({
    required this.genres,
    required this.id,
    required this.overview,
    required this.releaseDate,
    required this.runtime,
    required this.title,
  });

  List<Genre> genres;
  int id;
  String overview;
  DateTime releaseDate;
  int runtime;
  String title;

  factory DetailMovieModel.fromJson(Map<String, dynamic> json) =>
      DetailMovieModel(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        id: json["id"],
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
        runtime: json["runtime"],
        title: json["title"],
      );
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );
}
