import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movieflix'),
      ),
      body: Column(
        children: const [
          PopularMoviesScreen(),
          SizedBox(
            height: 20,
          ),
          NowInCinemaScreen(),
          SizedBox(
            height: 20,
          ),
          ComingSoonScreen(),
          // 스크롤이 가능한 위젯들을 넣으세요
        ],
      ),
    );
  }
}

/// CommingSoon Model

ComingSoonModel comingSoonModelFromJson(String str) =>
    ComingSoonModel.fromJson(json.decode(str));

class ComingSoonModel {
  ComingSoonModel({
    required this.adult,
    required this.backdropPath,
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
  String backdropPath;
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

  factory ComingSoonModel.fromJson(Map<String, dynamic> json) =>
      ComingSoonModel(
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

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
  });

  Future<List<ComingSoonModel>> fetchData() async {
    List<ComingSoonModel> movies = [];
    const path = 'https://movies-api.nomadcoders.workers.dev/coming-soon';

    final Dio dio = Dio();
    final response = await dio.get(path);
    print(response.data['results']);

    final json = response.data['results'];

    for (final ajson in json) {
      movies.add(ComingSoonModel.fromJson(ajson));
    }
    print('MOVIES: ${movies.length}');

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coming soon',
            style: titleStyle,
          ),
          FutureBuilder<List<ComingSoonModel>>(
              future: fetchData(),
              builder: (context, snapshot) {
                print('SNAPSHOT: ${snapshot.data}');

                if (snapshot.hasData) {
                  final movies = snapshot.data!;

                  return Expanded(
                    child: ListView.separated(
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
                                  // width: 140,
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
                            Text(
                              movies[index].title,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  print(snapshot.error.toString());
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}

// NowMovies MODEL
// To parse this JSON data, do
//
//     final nowMovies = nowMoviesFromJson(jsonString);

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

class NowInCinemaScreen extends StatelessWidget {
  const NowInCinemaScreen({
    super.key,
  });

  Future<List<NowMoviesModel>> fetchData() async {
    List<NowMoviesModel> movies = [];

    final Dio dio = Dio();
    final response =
        await dio.get('https://movies-api.nomadcoders.workers.dev/now-playing');

    // print('Now: ${response.data['results']}');

    for (final movie in response.data['results']) {
      movies.add(NowMoviesModel.fromJson(movie));
    }
    // print(movies);

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Now in Cinemas',
            style: titleStyle,
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Expanded(
            child: FutureBuilder<List<NowMoviesModel>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    final List<NowMoviesModel> movies = snapshot.data!;

                    return ListView.separated(
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
                                  // width: 140,
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
                            Text(
                              movies[index].title,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
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

// Popular Movies MODEL...

const movieHeader = 'https://image.tmdb.org/t/p/w500';

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

// Detail MODEL
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

class DetailScreen extends StatelessWidget {
  final int id;
  final String posterUrl;

  const DetailScreen({super.key, required this.id, required this.posterUrl});

  Future<DetailMovieModel> fetchData() async {
    final dio = Dio();
    const idUrl = 'https://movies-api.nomadcoders.workers.dev/movie';
    // print(idUrl);
    final response = await dio.get(idUrl, queryParameters: {'id': id});
    // print(response.data);

    final DetailMovieModel detail = DetailMovieModel.fromJson(response.data);
    // print('0--> $detail');
    return detail;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    // print(id.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Back to list')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DetailMovieModel>(
          future: fetchData(),
          builder: (context, snapshot) {
            // print('1-- ${snapshot.data}');

            if (snapshot.hasError) {
              print(snapshot.error.toString());

              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final detail = snapshot.data!;

              // print('2-- ${snapshot.data}');
              return Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: id,
                    child: Container(
                      width: 250,
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
                      child: Image.network(posterUrl),
                    ),
                  ),
                  Text(
                    detail.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    detail.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Runtime: ${detail.runtime} min', style: style),
                  Text(
                      'Release Date: ${detail.releaseDate.toString().split(' ').first.substring(0, 10)}',
                      style: style),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: detail.genres
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                e.name,
                                style: style,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
