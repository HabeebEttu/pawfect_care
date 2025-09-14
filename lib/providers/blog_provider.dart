import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/services/blog_service.dart';

/// Simple provider that lets you access BlogService anywhere in the app
final blogServiceProvider = Provider<BlogService>((ref) {
  return BlogService();
});
