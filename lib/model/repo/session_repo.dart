import 'dart:convert';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/local/pref.dart';
import 'package:covidoc/utils/const/const.dart';

class SessionRepository {
  final Pref pref;

  const SessionRepository(this.pref);

  Future<bool> flushAll() async {
    return pref.flushAll();
  }

  Future<bool> cacheSignInType(String type) {
    return pref.saveString(AppConst.CACHE_LOGIN_TYPE, type);
  }

  Future<String> getSignInType() {
    return pref.getString(AppConst.CACHE_LOGIN_TYPE);
  }

  Future<bool> cacheUser(AppUser user) async {
    return pref.saveString(AppConst.CACHE_USER, jsonEncode(user));
  }

  Future<AppUser> getUser() async {
    final data = await pref.getString(AppConst.CACHE_USER);
    if (data == null) {
      return null;
    }
    return AppUser.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<bool> cacheDoctors(List<AppUser> doctors) async {
    return pref.saveString(AppConst.CACHE_DOCTORS, jsonEncode(doctors));
  }

  Future<List<AppUser>> getDoctors(List<AppUser> doctors) async {
    final docs = await pref.getString(AppConst.CACHE_DOCTORS);
    if (docs == null || docs.isEmpty) {
      return [];
    }
    return (jsonDecode(docs) as List)
        ?.map(
          (d) => d == null ? null : AppUser.fromJson(d as Map<String, dynamic>),
        )
        ?.toList();
  }
}
