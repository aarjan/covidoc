import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog.g.dart';

enum BlogType { Featured, Regular }

@JsonSerializable()
class Blog extends Equatable {
  final int id;
  final String url;
  final String title;
  final bool featured;
  final String seoTitle;
  final String description;
  final DateTime publishedBy;
  final String blogImg;
  final int categoryID;
  final DateTime publishedAt;
  final String categoryTitle;
  final String seoDescription;

  const Blog(
      {this.id,
      this.url,
      this.title,
      this.featured,
      this.seoTitle,
      this.description,
      this.publishedBy,
      this.blogImg,
      this.categoryID,
      this.publishedAt,
      this.categoryTitle,
      this.seoDescription});

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  Map<String, dynamic> toJson() => _$BlogToJson(this);

  @override
  List<Object> get props => [
        id,
        url,
        title,
        featured,
        blogImg,
        description,
        categoryID,
        publishedAt,
        categoryTitle,
        seoTitle,
        seoDescription,
        publishedBy
      ];

  @override
  String toString() {
    return 'Blog: { id: $id, title: $title, url: $url, featured: $featured }';
  }
}
