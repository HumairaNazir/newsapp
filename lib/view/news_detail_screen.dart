import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    print(widget.article.toString());
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                height: height * .45,
                imageUrl: widget.article.urlToImage,
                fit: BoxFit.cover,
                placeholder: (context, ulr) =>
                    Center(child: SpinKitCircle(size: 50, color: Colors.blue)),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .45),
            decoration: BoxDecoration(color: Colors.white70),
            child: ListView(children: [Text(widget.article.title.toString())]),
          ),
        ],
      ),
    );
  }
}
