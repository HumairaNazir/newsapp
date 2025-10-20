import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  var article;
  NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final format = DateFormat('MMM d, h:mm a');
    print(widget.article.toString());
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child:
                  (widget.article.urlToImage != null &&
                      widget.article.urlToImage!.isNotEmpty)
                  ? CachedNetworkImage(
                      height: height * .45,
                      imageUrl: widget.article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SpinKitCircle(size: 50, color: Colors.blue),
                      ),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl:
                            'https://via.placeholder.com/400x200.png?text=No+Image+Available',
                        fit: BoxFit.cover,
                      ),
                    )
                  : CachedNetworkImage(
                      height: height * .45,
                      imageUrl:
                          'https://via.placeholder.com/400x200.png?text=No+Image+Available',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .44),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(35),
                topLeft: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Text(
                    widget.article.title ?? 'No title',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * .02),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.article.source.name ?? 'Unknown Source',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.article.publishedAt != null)
                        Text(
                          '• ${format.format(DateTime.parse(widget.article.publishedAt!))}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: height * .03),
                  Text(
                    widget.article.description ?? 'No description',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
