import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topnewsapp/models/catgegories_news_model.dart';
import 'package:topnewsapp/models/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
    String source,
  ) async {
    try {
      if (!await isConnected()) {
        throw Exception('No Internet Connection');
      }

      String url =
          'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=2d673db3a97f4077b9b0b6c1f1e9a15a';
      final response = await http.get(Uri.parse(url));
      print('🔗 Fetching URL: $url');

      if (response.statusCode == 200) {
        print("✅ Status Code: ${response.statusCode}");
        if (kDebugMode) {
          print(response.body);
        }
        final body = jsonDecode(response.body);
        return NewsChannelHeadlinesModel.fromJson(body);
      } else {
        throw Exception('Error fetching headlines');
      }
    } catch (e) {
      debugPrint('⚠️ Exception caught: $e');
      throw Exception('Failed to fetch news: $e');
    }
  }

  Future<CategoriesNewsModel> categoriesNewsApi(String category) async {
    try {
      if (!await isConnected()) {
        throw Exception('No Internet Connection');
      }

      String url =
          'https://newsapi.org/v2/everything?q=$category&language=en&apiKey=2d673db3a97f4077b9b0b6c1f1e9a15a';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return CategoriesNewsModel.fromJson(body);
      } else {
        throw Exception('Error fetching category news');
      }
    } catch (e) {
      debugPrint('⚠️ Exception caught: $e');
      throw Exception('Failed to fetch category news: $e');
    }
  }

  Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      final result = await http.get(Uri.parse('https://www.google.com'));
      return result.statusCode == 200;
    } catch (e) {
      debugPrint('⚠️ Internet check failed: $e');
      return false;
    }
  }

  Future<NewsChannelHeadlinesModel> searchNewsApi(String query) async {
    try {
      if (!await isConnected()) {
        throw Exception('No Internet Connection');
      }

      final url =
          'https://newsapi.org/v2/everything?q=$query&apiKey=2d673db3a97f4077b9b0b6c1f1e9a15a';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return NewsChannelHeadlinesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      debugPrint('⚠️ Exception caught: $e');
      throw Exception('Failed to fetch search results: $e');
    }
  }
}
