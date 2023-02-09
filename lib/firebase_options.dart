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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBOfFBqMjw9PteXJ81B1r3XkVesmioPec',
    appId: '1:182829506425:android:1c326ed6e2584f0412d9a8',
    messagingSenderId: '182829506425',
    projectId: 'timezone-b9cf8',
    databaseURL: 'https://timezone-b9cf8-default-rtdb.firebaseio.com',
    storageBucket: 'timezone-b9cf8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcr8YDBkfNg-zcuOynINFiVElbojzOnkE',
    appId: '1:182829506425:ios:84ca29e782be834412d9a8',
    messagingSenderId: '182829506425',
    projectId: 'timezone-b9cf8',
    databaseURL: 'https://timezone-b9cf8-default-rtdb.firebaseio.com',
    storageBucket: 'timezone-b9cf8.appspot.com',
    iosClientId: '182829506425-otvtqj8147rkceb5gsri6rb3er5blddb.apps.googleusercontent.com',
    iosBundleId: 'com.example.papprototype',
  );
}