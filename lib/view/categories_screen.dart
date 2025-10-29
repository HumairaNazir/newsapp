import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:topnewsapp/models/catgegories_news_model.dart';

import '../utilities/app_routes.dart';
import '../view_model/news_view_model.dart';
import '../widgets/error_message_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final NewViewModel newViewModel = NewViewModel();
  final format = DateFormat('MMM d, h:mm a');
  String categoryName = 'General';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index]
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              categoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newViewModel.categoriesNewsApi(categoryName),
                builder: (context, snapshot) {
                  print('🔍 Current selected source: $categoryName');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitChasingDots(color: Colors.blue, size: 50),
                    );
                  } else if (snapshot.hasError) {
                    print('❌ Error: ${snapshot.error}');
                    return ErrorMessageWidget(
                      onRetry: () => setState(() {}),
                      title: 'Something went wrong!',
                      message: 'Error: ${snapshot.error}',
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null) {
                    return const Center(child: Text('No news available.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.articles?.length ?? 0,
                      itemBuilder: (context, index) {
                        final article = snapshot.data!.articles![index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              detailScreenRoute,
                              arguments: article,
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width: width * .3,
                                    placeholder: (context, url) => const Center(
                                      child: SpinKitCircle(
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        article.title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              article.source?.name ?? '',
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
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
    );
  }
}
