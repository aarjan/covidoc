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

  Future<List<AppUser>> loadDoctors({int limit = 10}) async {
    final firestore = FirebaseFirestore.instance;
    final dRef = await firestore
        .collection('user')
        .where('type', isEqualTo: 'Doctor')
        .limit(limit)
        .get();
    if (dRef != null && dRef.docs.isNotEmpty) {
      final doctors = dRef.docs
          ?.map((d) => d == null ? null : AppUser.fromJson(d.data()))
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
