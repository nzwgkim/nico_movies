import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../model/now_movies_model.dart';
import 'detail_screen.dart';

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
