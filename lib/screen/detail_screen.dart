import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common.dart';
import '../model/detail_movie_model.dart';

class DetailScreen extends ConsumerWidget {
  final int id;
  final String posterUrl;

  const DetailScreen({super.key, required this.id, required this.posterUrl});

  Future<DetailMovieModel> fetchData(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);

    const idUrl = 'https://movies-api.nomadcoders.workers.dev/movie';
    // print(idUrl);
    final response = await dio.get(idUrl, queryParameters: {'id': id});
    // print(response.data);

    final DetailMovieModel detail = DetailMovieModel.fromJson(response.data);
    // print('0--> $detail');
    return detail;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const TextStyle style =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    // print(id.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Back to list')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DetailMovieModel>(
          future: fetchData(ref),
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
