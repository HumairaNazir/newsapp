import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:topnewsapp/widgets/error_message_widget.dart';
import '../models/news_channel_headlines_model.dart';
import '../view_model/news_view_model.dart';
import '../utilities/app_routes.dart';

class SearchNewsScreen extends StatefulWidget {
  const SearchNewsScreen({super.key});

  @override
  State<SearchNewsScreen> createState() => _SearchNewsScreenState();
}

class _SearchNewsScreenState extends State<SearchNewsScreen> {
  final NewViewModel newsViewModel = NewViewModel();
  final TextEditingController _searchController = TextEditingController();
  final format = DateFormat('MMM d, h:mm a');

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search News',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  query = value.trim();
                });
              },
            ),
            const SizedBox(height: 20),
            if (query.isEmpty)
              const Center(child: Text('Type something to search news.'))
            else
              Expanded(
                child: FutureBuilder<NewsChannelHeadlinesModel>(
                  future: newsViewModel.searchNewsApi(query),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitChasingDots(color: Colors.blue, size: 50),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: ErrorMessageWidget(
                          onRetry: () {},
                          title: 'Please check Internet Connection',
                          message: 'Something went wronged',
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.articles == null ||
                        snapshot.data!.articles!.isEmpty) {
                      return const Center(child: Text('No news found.'));
                    } else {
                      final articles = snapshot.data!.articles!;
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    article.urlToImage ??
                                    'https://via.placeholder.com/100x100.png?text=No+Image',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              article.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              article.source?.name ?? 'Unknown Source',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                detailScreenRoute,
                                arguments: article,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
