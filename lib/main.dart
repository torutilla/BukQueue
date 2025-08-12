// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_try_thesis/firebase_options.dart';
import 'package:flutter_try_thesis/models/cache_manager/sqlite_operations/sqliteOperations.dart';
import 'package:flutter_try_thesis/routing/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await dotenv.load(fileName: ".env");
  final sql = SqliteOperations();
  await sql.initDatabase();
  final user = FirebaseAuth.instance.currentUser;
  print('Current user at app start: ${user?.uid}');
  // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  // const initSettings = InitializationSettings(android: android);
  // flutterLocalNotificationsPlugin.initialize(initSettings);
  // flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()!
  //     .requestNotificationsPermission();
  //
  // print('Initial App Check token: ${tokenResult}');
  // FirebaseAuth.instance.signOut();
  runApp(MyRouter());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
}
