import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:topnewsapp/models/news_channel_headlines_model.dart';
import 'package:topnewsapp/models/catgegories_news_model.dart';
import 'package:topnewsapp/utilities/app_routes.dart';
import 'package:topnewsapp/view_model/news_view_model.dart';
import '../widgets/error_message_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  final NewViewModel newViewModel = NewViewModel();
  final format = DateFormat('MMM d, h:mm a');
  String name = 'bbc-news';
  FilterList? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return SafeArea(
      child: Scaffold(
        // ✅ Add a Drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hello, Humaira 👋',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ],
          ),
        ),

        // ✅ Main body
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'News',
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
            PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item) {
                setState(() {
                  selectedMenu = item;
                  if (item == FilterList.bbcNews) {
                    name = 'bbc-news';
                  } else if (item == FilterList.aryNews) {
                    name = 'ary-news';
                  } else if (item == FilterList.cnn) {
                    name = 'cnn';
                  } else if (item == FilterList.alJazeera) {
                    name = 'al-jazeera-english';
                  }
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                const PopupMenuItem(
                  value: FilterList.bbcNews,
                  child: Text('BBC News'),
                ),
                const PopupMenuItem(
                  value: FilterList.aryNews,
                  child: Text('Ary News'),
                ),
                const PopupMenuItem(value: FilterList.cnn, child: Text('CNN')),
                const PopupMenuItem(
                  value: FilterList.alJazeera,
                  child: Text('Al Jazeera'),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.black),
            ),
          ],
        ),

        // ✅ Body with SingleChildScrollView (to fix overflow)
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Headlines Section
                FutureBuilder<NewsChannelHeadlinesModel>(
                  future: newViewModel.fetchNewsChannelHeadlinesApi(name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: SpinKitChasingDots(
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ErrorMessageWidget(
                        onRetry: () => setState(() {}),
                        title: 'Something went wrong!',
                        message:
                            'Please check your internet connection and try again.',
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.articles == null) {
                      return const Center(child: Text('No news available.'));
                    } else {
                      final articles = snapshot.data!.articles!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    detailScreenRoute,
                                    arguments: article,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: article.urlToImage ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child: SpinKitCircle(
                                                color: Colors.blue,
                                                size: 50,
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.error_outline,
                                              size: 50,
                                              color: Colors.red,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  article.source?.name ??
                                                      'Unknown Source',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white70,
                                                    fontSize: 13,
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
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: height * 0.35,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              viewportFraction: 0.95,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<CategoriesNewsModel>(
                    future: newViewModel.categoriesNewsApi('general'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: SpinKitThreeBounce(
                            color: Colors.blue,
                            size: 20,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return ErrorMessageWidget(
                          onRetry: () => setState(() {}),
                          title: 'Something went wrong!',
                          message: 'Error: ${snapshot.error}',
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.articles == null) {
                        return const Center(child: Text('No news available.'));
                      } else {
                        final articles = snapshot.data!.articles!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage ?? '',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 120,
                                      placeholder: (context, url) =>
                                          const Center(
                                            child: SpinKitCircle(
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title ?? '',
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                article.source?.name ?? '',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.red,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            if (article.publishedAt != null)
                                              Text(
                                                '• ${format.format(DateTime.parse(article.publishedAt!))}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
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
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
