// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBuJOPQ5bLUHB9PPgLRdW8_T5xfVqOaC_A',
    appId: '1:656760551321:web:393e01292e8e5da9558508',
    messagingSenderId: '656760551321',
    projectId: 'jarum-f9fc3',
    authDomain: 'jarum-f9fc3.firebaseapp.com',
    databaseURL: 'https://jarum-f9fc3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jarum-f9fc3.appspot.com',
    measurementId: 'G-XLFDQGKCL9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZIMhnfnk6h2Is0iRWGPKvQo3yi3i0-7o',
    appId: '1:656760551321:android:7e7f537a9292e53f558508',
    messagingSenderId: '656760551321',
    projectId: 'jarum-f9fc3',
    databaseURL: 'https://jarum-f9fc3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jarum-f9fc3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBY3pDqWV_GkX8rGinPjWSCrHEzy_S90VQ',
    appId: '1:656760551321:ios:4208778a5223371b558508',
    messagingSenderId: '656760551321',
    projectId: 'jarum-f9fc3',
    databaseURL: 'https://jarum-f9fc3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jarum-f9fc3.appspot.com',
    iosBundleId: 'com.example.projectJarum',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBY3pDqWV_GkX8rGinPjWSCrHEzy_S90VQ',
    appId: '1:656760551321:ios:0b5afbe43da27416558508',
    messagingSenderId: '656760551321',
    projectId: 'jarum-f9fc3',
    databaseURL: 'https://jarum-f9fc3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jarum-f9fc3.appspot.com',
    iosBundleId: 'com.example.projectJarum.RunnerTests',
  );
}