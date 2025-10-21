import 'package:topnewsapp/models/catgegories_news_model.dart';
import 'package:topnewsapp/repository/news_repository.dart';

import '../models/news_channel_headlines_model.dart';

class NewViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
    String source,
  ) async {
    final response = _repo.fetchNewsChannelHeadlinesApi(source);
    return response;
  }

  Future<CategoriesNewsModel> categoriesNewsApi(String category) async {
    final response = _repo.categoriesNewsApi(category);
    return response;
  }

  Future<NewsChannelHeadlinesModel> searchNewsApi(String query) async {
    final response = _repo.searchNewsApi(query);
    return response;
  }
}
