import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsContainer extends StatelessWidget {
  final String imageUrl, title, description, publishedAt, source;

  const NewsContainer({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: size.height * 0.45,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                height: size.height * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: size.height * 0.25,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),

            const Spacer(),

            // Published Date & Source
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    source,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    publishedAt,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
