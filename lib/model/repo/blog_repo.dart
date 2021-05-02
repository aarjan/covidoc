import 'dart:convert';

import 'package:covidoc/core/error/failures.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:either_option/either_option.dart';
import 'package:http/http.dart' as http;

class BlogRepo {
  final SessionRepository sessionRepo;

  BlogRepo(this.sessionRepo);

  Future<Either<ServerFailure, BlogResp>> getBlogs({
    int limit = 20,
    int offset = 0,
    bool featured = false,
  }) async {
    try {
      final response =
          await http.get('${AppConst.BLOG_URL}?limit=$limit&offset=$offset');
      final resp = BlogResp.fromJson(jsonDecode(response.body));
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}
