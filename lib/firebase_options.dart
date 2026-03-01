import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyC1CFJAyJpJwdJQ4Io_sEJtsloQkTvrqiQ',
    appId: '1:1095951672929:web:9f9944237eba6c68a86c20',
    messagingSenderId: '1095951672929',
    projectId: 'autoroutine-92c6d',
    authDomain: 'autoroutine-92c6d.firebaseapp.com',
    storageBucket: 'autoroutine-92c6d.firebasestorage.app',
    measurementId: 'G-9EWG5FGVB7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4bHlzxy2AMzwRK6_yzkHZ5Rafk2Te6Ew',
    appId: '1:1095951672929:android:804b6c8395cb25a2a86c20',
    messagingSenderId: '1095951672929',
    projectId: 'autoroutine-92c6d',
    storageBucket: 'autoroutine-92c6d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkY8JnDt5MQOwPEOVy15fJL_P-qbsPR98',
    appId: '1:1095951672929:ios:33555c4add1c0ecca86c20',
    messagingSenderId: '1095951672929',
    projectId: 'autoroutine-92c6d',
    storageBucket: 'autoroutine-92c6d.firebasestorage.app',
    iosClientId:
        '1095951672929-7jlma83i4ajmf1993a4560hah3g971r2.apps.googleusercontent.com',
    iosBundleId: 'com.example.autoRoutine',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkY8JnDt5MQOwPEOVy15fJL_P-qbsPR98',
    appId: '1:1095951672929:ios:33555c4add1c0ecca86c20',
    messagingSenderId: '1095951672929',
    projectId: 'autoroutine-92c6d',
    storageBucket: 'autoroutine-92c6d.firebasestorage.app',
    iosClientId:
        '1095951672929-7jlma83i4ajmf1993a4560hah3g971r2.apps.googleusercontent.com',
    iosBundleId: 'com.example.autoRoutine',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1CFJAyJpJwdJQ4Io_sEJtsloQkTvrqiQ',
    appId: '1:1095951672929:web:9c25ad3dafc97af7a86c20',
    messagingSenderId: '1095951672929',
    projectId: 'autoroutine-92c6d',
    authDomain: 'autoroutine-92c6d.firebaseapp.com',
    storageBucket: 'autoroutine-92c6d.firebasestorage.app',
    measurementId: 'G-BCGE2CB36P',
  );
}
