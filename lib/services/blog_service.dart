import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/articles.dart';

class PetStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Articles>> fetchBlogs() async {
    final snapshot = await _db.collection('blogs').get();
    return snapshot.docs.map((doc) => Articles.fromMap(doc.data())).toList();
  }
}
