import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/articles.dart';

class PetStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Articles>> fetchBlogs() async {
    final snapshot = await _db.collection('blogs').get();
    return snapshot.docs.map((doc) => Articles.fromMap(doc.data())).toList();
  }
}
import 'package:pawfect_care/models/article.dart';

class BlogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addArticleToBlog(Article article) async {
    await _firestore.collection('blogs').doc(article.id).set(article.toMap());
  }

  Future<List<Article>> getAllArticles() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('blogs')
        .get();

    return snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
  }

  Future<Article?> getArticleById(String id) async {
    final doc = await _firestore.collection('blogs').doc(id).get();
    if (doc.exists) {
      return Article.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateArticle(Article article) async {
    await _firestore.collection('blogs').doc(article.id).update(article.toMap
      ());
  }

  Future<void> deleteArticle(String id) async {
    await _firestore.collection('blogs').doc(id).delete();
  }

  Stream<List<Article>> streamAllArticles() {
    return _firestore
        .collection('blogs')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList(),
        );
  }

  Future<List<Article>> searchArticles(String keyword) async {
    final snapshot = await _firestore
        .collection('blogs')
        .where('title', isGreaterThanOrEqualTo: keyword)
        .where('title', isLessThanOrEqualTo: keyword + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
  }
}

>>>>>>> 8d669b4211c66860de0456aeda8c6a6338e7f0bd
