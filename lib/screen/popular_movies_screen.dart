import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nico_movies/common/interceptor.dart';

import '../common/common.dart';
import '../model/popular_movies_model.dart';
import 'detail_screen.dart';

class PopularMoviesScreen extends StatelessWidget {
  const PopularMoviesScreen({
    super.key,
  });

  Future<List<PopularMoviesModel>> fetchData() async {
    final List<PopularMoviesModel> movies = [];
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor());

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
