import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/coming_soon_screen.dart';
import 'screen/now_in_cinema_screen.dart';
import 'screen/popular_movies_screen.dart';

void main() {
  runApp(const ProviderScope(child: App()));
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
        ],
      ),
    );
  }
}
