import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../common/interceptor.dart';
import '../model/coming_soon_model.dart';
import 'detail_screen.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
  });

  Future<List<ComingSoonModel>> fetchData() async {
    List<ComingSoonModel> movies = [];
    const path = 'https://movies-api.nomadcoders.workers.dev/coming-soon';

    final Dio dio = Dio();
    dio.interceptors.add(CustomInterceptor());

    final response = await dio.get(path);
    // print(response.data['results']);

    final json = response.data['results'];

    for (final ajson in json) {
      movies.add(ComingSoonModel.fromJson(ajson));
    }
    // print('MOVIES: ${movies.length}');

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
                // print('SNAPSHOT: ${snapshot.data}');

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
