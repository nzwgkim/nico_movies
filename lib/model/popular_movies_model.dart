// Popular Movies MODEL...

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../screen/detail_screen.dart';

PopularMoviesModel popularMoviesFromJson(String str) =>
    PopularMoviesModel.fromJson(json.decode(str));

class PopularMoviesModel {
  PopularMoviesModel({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  factory PopularMoviesModel.fromJson(Map<String, dynamic> json) =>
      PopularMoviesModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );
}

class PopularMoviesScreen extends StatelessWidget {
  const PopularMoviesScreen({
    super.key,
  });

  Future<List<PopularMoviesModel>> fetchData() async {
    final List<PopularMoviesModel> movies = [];
    final dio = Dio();
    final response =
        await dio.get('https://movies-api.nomadcoders.workers.dev/popular');
    // print(response.data['results']);
    final List<dynamic> json = response.data['results'];
    // print(json.length);

    for (final ajson in json) {
      final movie = PopularMoviesModel.fromJson(ajson);
      // print(movie.title);
      movies.add(movie);
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Popular Movies',
            style: titleStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<PopularMoviesModel>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    final List<PopularMoviesModel> movies = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 20,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final posterUrl =
                            movieHeader + movies[index].posterPath;
                        // print(posterUrl);
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      id: movies[index].id,
                                      posterUrl: posterUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: movies[index].id,
                                child: Container(
                                  // width: 180,
                                  height: 165,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 15,
                                        offset: const Offset(10, 10),
                                        color: Colors.black.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                  child: Image.network(
                                    posterUrl,
                                  ),
                                ),
                              ),
                            ),
                            // Text(
                            //   movies[index].title,
                            //   style: const TextStyle(
                            //       fontSize: 14, fontWeight: FontWeight.w600),
                            // ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
