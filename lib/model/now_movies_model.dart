// NowMovies MODEL
// To parse this JSON data, do
//
//     final nowMovies = nowMoviesFromJson(jsonString);

import 'dart:convert';

NowMoviesModel nowMoviesFromJson(String str) =>
    NowMoviesModel.fromJson(json.decode(str));

class NowMoviesModel {
  NowMoviesModel({
    required this.genreIds,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
  });

  List<int> genreIds;
  int id;
  String overview;
  String posterPath;
  String title;

  factory NowMoviesModel.fromJson(Map<String, dynamic> json) => NowMoviesModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        title: json["title"],
      );
}
