import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class BlogDetailScreen extends StatelessWidget {
  static const ROUTE_NAME = '/blogDetail';

  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Guidelines',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                blog.url!,
                subject: 'Check this blog on covidoc!',
              );
            },
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(Icons.share_rounded, color: AppColors.BLACK),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 214,
                    imageUrl: blog.blogImg!,
                    errorWidget: (_, url, err) =>
                        const Center(child: Icon(Icons.error_outline)),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(blog.categoryTitle!,
                          style: AppFonts.REGULAR_GREEN1_12),
                    ),
                    Text(blog.publishedAt!.formattedTime,
                        style: AppFonts.REGULAR_WHITE3_12),
                    Container(
                      width: 2,
                      height: 2,
                      color: AppColors.BLACK3,
                      margin: const EdgeInsets.all(10),
                    ),
                    Text(blog.description!.readingDuration,
                        style: AppFonts.REGULAR_WHITE3_12),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  blog.title!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.MEDIUM_BLACK3_20,
                ),
                const SizedBox(height: 10),
                // Row(
                //   children: [
                //     const CircleAvatar(
                //       radius: 13,
                //     ),
                //     const SizedBox(width: 10),
                //   ],
                // ),
                Text(
                  'Admin',
                  style: AppFonts.REGULAR_BLACK3_14,
                ),
                const Divider(
                  height: 32,
                ),

                HtmlWidget(
                  blog.description!,
                  onTapUrl: launchURL,
                  buildAsync: true,
                  textStyle: AppFonts.REGULAR_BLACK3_14,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
