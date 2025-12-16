import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/app_config.dart';

/// Firebase service for optional Firebase initialization.
/// 
/// This service is only initialized when Firebase is enabled in AppConfig.
/// The app can run without Firebase for development and testing.
class FirebaseService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize Firebase if enabled in configuration.
  /// 
  /// Returns true if successfully initialized, false otherwise.
  static Future<bool> initialize() async {
    // Check if Firebase should be enabled
    if (!AppConfig.current.enableFirebase) {
      print('Firebase is disabled in configuration');
      return false;
    }

    try {
      // Initialize Firebase
      // TODO: Add firebase_options.dart with Firebase configuration
      // Generate using: flutterfire configure
      await Firebase.initializeApp();
      
      // Initialize Firebase Messaging
      await _initializeMessaging();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      print('Firebase initialized successfully');
      return true;
    } catch (e) {
      print('Firebase initialization failed: $e');
      print('App will run without Firebase features');
      return false;
    }
  }

  /// Initialize Firebase Cloud Messaging
  static Future<void> _initializeMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
      
      // Get FCM token
      final token = await messaging.getToken();
      print('FCM Token: $token');
      
      // TODO: Send token to backend
      
      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken');
        // TODO: Send updated token to backend
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    } else {
      print('User declined notification permission');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // TODO: Handle notification tap
        print('Notification tapped: ${details.payload}');
      },
    );
  }

  /// Handle foreground message
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.messageId}');
    
    // Show local notification
    const androidDetails = AndroidNotificationDetails(
      'prava_messages',
      'Messages',
      channelDescription: 'New messages and notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New notification',
      message.notification?.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }

  /// Handle background message
  /// Must be a top-level function
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Background message received: ${message.messageId}');
    // Background messages are handled by the OS notification system
  }
}
