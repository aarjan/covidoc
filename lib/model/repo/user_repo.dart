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

  Future<List<AppUser>> loadUsers({
    String? userId,
    int limit = 10,
    required List<String?> userIds,
    String? userType = 'Doctor',
  }) async {
    final firestore = FirebaseFirestore.instance;
    final dRef = await firestore
        .collection('user')
        // .where('type', isEqualTo: userType)
        .where(FieldPath.documentId,
            whereNotIn: userIds.isEmpty ? [' '] : userIds)
        .limit(limit)
        .get();

    if (dRef.docs.isNotEmpty) {
      final doctors = dRef.docs
          .map((d) => AppUser.fromJson(d.data()))
          .where((d) => d.id != userId)
          .toList();

      return doctors;
    }
    return [];
  }

  Future<AppUser?> loadUser(String? userId) async {
    final firestore = FirebaseFirestore.instance;
    final uRef = await firestore.doc('user/$userId').get();
    if (uRef.exists) {
      return AppUser.fromJson(uRef.data()!);
    }
    return null;
  }

  Future<AppUser?> getUser() async {
    return sessionRepo.getUser();
  }

  Future<void> cacheUser(AppUser user) async {
    await sessionRepo.cacheUser(user);
  }
}
