import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidoc/bloc/blog/blog.dart';
import 'package:covidoc/model/repo/blog_repo.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepo repo;

  BlogBloc(this.repo)
      : assert(repo != null),
        super(BlogInitial());

  @override
  Stream<BlogState> mapEventToState(BlogEvent event) async* {
    try {
      switch (event.runtimeType) {
        case LoadBlog:
          yield* _mapBlogLoadEventToState(event as LoadBlog);
          break;
        case LoadFeaturedBlog:
          yield* _mapBlogFeaturedLoadEventToState(event as LoadFeaturedBlog);
          break;
        default:
      }
    } catch (e) {
      yield BlogLoadFailure(e.toString());
    }
  }

  Stream<BlogState> _mapBlogLoadEventToState(LoadBlog event) async* {
    if (state is BlogLoadSuccess) {
      final currentState = state as BlogLoadSuccess;

      if (currentState.regularBlogs.hasReachedEnd) {
        return;
      }

      final blogs = await repo.getBlogs(
        offset: currentState.regularBlogs.blogs.length,
      );

      yield BlogLoadInProgress();

      yield* blogs.fold(
        (f) async* {
          yield BlogLoadFailure(f.toString());
        },
        (b) async* {
          final updatedBlogs = currentState.regularBlogs.blogs + b.data;
          yield currentState.copyWith(
            regularBlogs: const BlogItem().copyWith(
                blogs: updatedBlogs,
                totalCount: b.totalCount,
                hasReachedEnd: updatedBlogs.length >= b.totalCount),
          );
        },
      );
      return;
    }
    yield BlogLoadInProgress();

    final blogs = await repo.getBlogs();
    yield blogs.fold(
      (f) => BlogLoadFailure(f.toString()),
      (b) => const BlogLoadSuccess().copyWith(
        regularBlogs: BlogItem(
            blogs: b.data,
            totalCount: b.totalCount,
            hasReachedEnd: b.data.length >= b.totalCount),
      ),
    );
  }

  Stream<BlogState> _mapBlogFeaturedLoadEventToState(
      LoadFeaturedBlog event) async* {
    if (state is BlogLoadSuccess) {
      final currentState = state as BlogLoadSuccess;

      if (currentState.featuredBlogs.hasReachedEnd) {
        return;
      }
      yield BlogLoadInProgress();

      final blogs = await repo.getBlogs(
        offset: currentState.featuredBlogs.blogs.length,
      );

      yield blogs.fold(
        (f) => BlogLoadFailure(f.toString()),
        (b) {
          final updatedBlogs = currentState.featuredBlogs.blogs + b.data;
          return currentState.copyWith(
            featuredBlogs: const BlogItem().copyWith(
                blogs: updatedBlogs,
                totalCount: b.totalCount,
                hasReachedEnd: updatedBlogs.length >= b.totalCount),
          );
        },
      );
      return;
    }
    yield BlogLoadInProgress();

    final blogs = await repo.getBlogs();
    yield blogs.fold(
      (f) => BlogLoadFailure(f.toString()),
      (b) => const BlogLoadSuccess().copyWith(
        featuredBlogs: BlogItem(
            blogs: b.data,
            totalCount: b.totalCount,
            hasReachedEnd: b.data.length >= b.totalCount),
      ),
    );
  }
}
