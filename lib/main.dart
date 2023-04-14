import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: const [
            SizedBox(
              height: 50,
            ),
            PopularMoviesScreen(),
          ],
        ),
      )),
    );
  }
}

// To parse this JSON data, do
//
//     final popularMovies = popularMoviesFromJson(jsonString);

const movieHeader = 'https://image.tmdb.org/t/p/w500';

PopularMovies popularMoviesFromJson(String str) =>
    PopularMovies.fromJson(json.decode(str));

class PopularMovies {
  PopularMovies({
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

  factory PopularMovies.fromJson(Map<String, dynamic> json) => PopularMovies(
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

  Future<List<PopularMovies>> fetchData() async {
    final List<PopularMovies> movies = [];
    final dio = Dio();
    final response =
        await dio.get('https://movies-api.nomadcoders.workers.dev/popular');
    // print(response.data['results']);
    final List<dynamic> json = response.data['results'];
    // print(json.length);

    for (final ajson in json) {
      final movie = PopularMovies.fromJson(ajson);
      print(movie.title);
      movies.add(movie);
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Movies',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<PopularMovies>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    final List<PopularMovies> movies = snapshot.data!;

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
                                    builder: (context) => Detail(
                                      id: movies[index].id,
                                      genreIds: movies[index].genreIds,
                                      overview: movies[index].overview,
                                      title: movies[index].title,
                                      posterUrl: posterUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: movies[index].id,
                                child: Container(
                                  width: 200,
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

class Detail extends StatelessWidget {
  final int id;
  final String title;
  final String overview;
  final List<int> genreIds;
  final String posterUrl;

  const Detail(
      {super.key,
      required this.id,
      required this.title,
      required this.overview,
      required this.genreIds,
      required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    print(id.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Back to list')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            ...genreIds.map((e) => SizedBox(
                  width: 10,
                  child: Text(
                    e.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
