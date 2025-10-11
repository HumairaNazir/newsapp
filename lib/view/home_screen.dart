import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:topnewsapp/models/news_channel_headlines_model.dart';
import 'package:topnewsapp/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/error_message_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewViewModel newViewModel = NewViewModel();
  final format = DateFormat('MMM d, h:mm a');
  String selectedChannel = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Column(
        children: [
          // ✅ AppBar Section
          AppBar(
            title: Text(
              'Home',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    selectedChannel = value;
                  });
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'bbc-news', child: Text('BBC News')),
                  PopupMenuItem(value: 'cnn', child: Text('CNN')),
                  PopupMenuItem(
                    value: 'al-jazeera-english',
                    child: Text('Al Jazeera'),
                  ),
                  PopupMenuItem(value: 'fox-news', child: Text('Fox News')),
                  PopupMenuItem(value: 'the-verge', child: Text('The Verge')),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          // ✅ Body Section
          Expanded(
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newViewModel.fetchNewsChannelHeadlinesApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitChasingDots(color: Colors.blue, size: 50),
                  );
                } else if (snapshot.hasError) {
                  return ErrorMessageWidget(onRetry: () => setState(() {}));
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return const Center(child: Text('No news available.'));
                } else {
                  final articles = snapshot.data!.articles!;
                  return ListView(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Top Headlines',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      CarouselSlider.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index, realIndex) {
                          final article = articles[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black54,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 10,
                                  right: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            article.source?.name ??
                                                'Unknown Source',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (article.publishedAt != null)
                                            Text(
                                              format.format(
                                                DateTime.parse(
                                                  article.publishedAt!,
                                                ),
                                              ),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: height * 0.40,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 0.99,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
