import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class BlogScreen extends StatelessWidget {
  static const ROUTE_NAME = '/blog';
  const BlogScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Guidelines', style: AppFonts.SEMIBOLD_BLACK3_18),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(builder: (context, state) {
        switch (state.runtimeType) {
          case BlogLoadSuccess:
            final curState = state as BlogLoadSuccess;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: curState.featuredBlogs.blogs.length,
              itemBuilder: (context, index) =>
                  BlogItem(curState.featuredBlogs.blogs[index]),
            );
          case BlogLoadFailure:
            final currState = state as BlogLoadFailure;
            return Center(
              child: Text(currState.error),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class BlogItem extends StatelessWidget {
  final Blog blog;

  const BlogItem(this.blog);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, getRoute(BlogDetailScreen(blog)));
        },
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    imageUrl: blog.blogImg,
                    errorWidget: (_, url, err) =>
                        const Center(child: Icon(Icons.error_outline)),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.categoryTitle,
                        style: AppFonts.REGULAR_GREEN1_12,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        blog.title,
                        style: AppFonts.REGULAR_BLACK3_14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            blog.publishedAt.formattedTime,
                            style: AppFonts.REGULAR_WHITE3_12,
                          ),
                          Container(
                            width: 2,
                            height: 2,
                            color: AppColors.BLACK3,
                            margin: const EdgeInsets.all(10),
                          ),
                          Text(blog.description.readingDuration,
                              style: AppFonts.REGULAR_WHITE3_12),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
