import 'package:flutter/material.dart';
import 'package:pawfect_care/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  bool _isInitialized = false;
  String? _fcmToken;
  int _unreadCount = 0;

  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;
  int get unreadCount => _unreadCount;

  void _setInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  void _setFcmToken(String? token) {
    _fcmToken = token;
    notifyListeners();
  }

  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  Future<void> initializeNotifications() async {
    if (!_isInitialized) {
      await _notificationService.initialize();
      _setInitialized(true);
      _fcmToken = await _notificationService.getFCMToken();
      _setFcmToken(_fcmToken);
    }
  }

  Future<void> sendTestNotification() async {
    await _notificationService.showTestNotification();
  }

  // You might add methods here to fetch notifications from Firestore
  // and manage their read/unread status.
}
