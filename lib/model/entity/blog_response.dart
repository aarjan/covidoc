import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'blog.dart';
part 'blog_response.g.dart';

@JsonSerializable()
class BlogResp extends Equatable {
  final List<Blog> data;
  final int totalCount;
  final bool status;
  final String message;

  const BlogResp({this.data, this.totalCount, this.status, this.message});

  factory BlogResp.fromJson(Map<String, dynamic> json) =>
      _$BlogRespFromJson(json);

  Map<String, dynamic> toJson() => _$BlogRespToJson(this);

  @override
  List<Object> get props => [data, totalCount, status, message];

  @override
  String toString() {
    return 'BlogResponse: { blogs: $data, totalCount: $totalCount }';
  }
}
