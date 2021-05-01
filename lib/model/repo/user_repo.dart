import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/entity/app_user.dart';
import 'package:covidoc/model/repo/session_repo.dart';

class UserRepo {
  final SessionRepository sessionRepo;

  UserRepo(this.sessionRepo);

  // add/overwrite user if existing
  Future<void> updateUser(AppUser user) async {
    final firestore = FirebaseFirestore.instance;
    final userInfo = user.toJson();
    await firestore.collection('user').doc(user.id).update(userInfo);
  }

  // [TODO]: Fix the query, can't query multiple fields at once
  Future<List<AppUser>> loadUsers({
    String userId,
    int limit = 10,
    String userType,
    List<String> chatIds,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final dRef = await firestore
        .collection('user')
        .where('chatIds', whereNotIn: chatIds.isEmpty ? [' '] : chatIds)
        // .where('type', isEqualTo: 'Doctor')
        // .where(FieldPath.documentId, isNotEqualTo: userId)
        .limit(limit)
        .get();
    if (dRef != null && dRef.docs.isNotEmpty) {
      final doctors = dRef.docs
          ?.map((d) => d == null ? null : AppUser.fromJson(d.data()))
          ?.where((d) => d.id != userId && d.type != userType)
          ?.toList();

      return doctors;
    }
    return [];
  }

  Future<AppUser> getUser() async {
    return sessionRepo.getUser();
  }

  Future<void> cacheUser(AppUser user) async {
    return sessionRepo.cacheUser(user);
  }
}
