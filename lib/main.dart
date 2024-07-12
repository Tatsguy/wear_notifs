import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SmartwatchApp());
}

class SmartwatchApp extends StatefulWidget {
  @override
  _SmartwatchAppState createState() => _SmartwatchAppState();
}

class _SmartwatchAppState extends State<SmartwatchApp> {
  String _messageText = 'Waiting for message...';

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token (Smartwatch): $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      setState(() {
        _messageText = message.notification?.title ?? 'No title';
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened from terminated state: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Smartwatch App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Message:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                _messageText,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
