import 'package:topnewsapp/repository/news_repository.dart';

import '../models/news_channel_headlines_model.dart';

class NewViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    final response = _repo.fetchNewsChannelHeadlinesApi();
    return response;
  }
}
