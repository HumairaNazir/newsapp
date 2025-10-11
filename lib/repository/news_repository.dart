import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart ' as http;
import 'package:topnewsapp/models/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=2d673db3a97f4077b9b0b6c1f1e9a15a';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
