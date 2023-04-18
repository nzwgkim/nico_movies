import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interceptor.dart';

const titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
const movieHeader = 'https://image.tmdb.org/t/p/w500';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(
    CustomInterceptor(),
  );
  return dio;
});
