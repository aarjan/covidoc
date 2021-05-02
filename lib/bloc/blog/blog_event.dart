import 'package:equatable/equatable.dart';
import 'package:covidoc/model/entity/blog.dart';

class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class LoadBlog extends BlogEvent {
  final int limit;
  final int offset;
  final bool addData;
  final BlogType type;

  const LoadBlog([
    this.type,
    this.limit = 10,
    this.offset = 0,
    this.addData = false,
  ]);

  @override
  List<Object> get props => [limit, offset, addData, type];

  @override
  String toString() {
    return 'LoadBlog: { limit: $limit, offset: $offset, '
        'addData: $addData, type: $type }';
  }
}

class LoadFeaturedBlog extends BlogEvent {
  final int limit;
  final int offset;
  final bool addData;
  final BlogType type;

  const LoadFeaturedBlog([
    this.type,
    this.limit = 10,
    this.offset = 0,
    // ignore: avoid_positional_boolean_parameters
    this.addData = false,
  ]);

  @override
  List<Object> get props => [limit, offset, addData, type];

  @override
  String toString() {
    return 'LoadFeaturedBlog: { limit: $limit, offset: $offset, '
        'addData: $addData, type: $type }';
  }
}
