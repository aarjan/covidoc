import 'package:equatable/equatable.dart';
import 'package:covidoc/model/entity/blog.dart';

class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoadInProgress extends BlogState {}

class BlogFeaturedLoadInProgress extends BlogState {}

class BlogItem {
  final int totalCount;
  final List<Blog> blogs;
  final bool hasReachedEnd;
  final BlogType type;

  const BlogItem({
    this.type,
    this.blogs = const [],
    this.totalCount = 0,
    this.hasReachedEnd = false,
  });

  BlogItem copyWith(
      {List<Blog> blogs, BlogType type, bool hasReachedEnd, int totalCount}) {
    return BlogItem(
      type: type ?? this.type,
      blogs: blogs ?? this.blogs,
      totalCount: totalCount ?? this.totalCount,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  String toString() {
    return 'BlogItem: { type:$type, totalCount: $totalCount, '
        'hasReachedEnd: $hasReachedEnd }';
  }
}

class BlogLoadSuccess extends BlogState {
  final BlogItem regularBlogs;
  final BlogItem featuredBlogs;

  const BlogLoadSuccess({
    this.regularBlogs = const BlogItem(),
    this.featuredBlogs = const BlogItem(),
  });

  @override
  List<Object> get props => [regularBlogs, featuredBlogs];

  BlogLoadSuccess copyWith({BlogItem regularBlogs, BlogItem featuredBlogs}) {
    return BlogLoadSuccess(
      regularBlogs: regularBlogs ?? this.regularBlogs,
      featuredBlogs: featuredBlogs ?? this.featuredBlogs,
    );
  }
}

class BlogLoadFailure extends BlogState {
  final String error;

  const BlogLoadFailure([this.error]);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'BlogLoadFailure: { error: $error }';
  }
}
