// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDzC2_yOGOC3_Vgu85ung81eII7xDFCoh8',
    appId: '1:489219364726:web:978161f46de964bb00cc57',
    messagingSenderId: '489219364726',
    projectId: 'noti-swd392',
    authDomain: 'noti-swd392.firebaseapp.com',
    storageBucket: 'noti-swd392.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPPry9Wtt4PPsoMTjFN614Y9m68LffiPY',
    appId: '1:489219364726:android:4972820945c244d500cc57',
    messagingSenderId: '489219364726',
    projectId: 'noti-swd392',
    storageBucket: 'noti-swd392.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvF71EFakvpmLYsjNgTqUunH0ukXPOxqA',
    appId: '1:489219364726:ios:c6296c2bfac9377200cc57',
    messagingSenderId: '489219364726',
    projectId: 'noti-swd392',
    storageBucket: 'noti-swd392.appspot.com',
    iosBundleId: 'com.example.moSwd392',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvF71EFakvpmLYsjNgTqUunH0ukXPOxqA',
    appId: '1:489219364726:ios:c6296c2bfac9377200cc57',
    messagingSenderId: '489219364726',
    projectId: 'noti-swd392',
    storageBucket: 'noti-swd392.appspot.com',
    iosBundleId: 'com.example.moSwd392',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDzC2_yOGOC3_Vgu85ung81eII7xDFCoh8',
    appId: '1:489219364726:web:ebe2ac3357d5127200cc57',
    messagingSenderId: '489219364726',
    projectId: 'noti-swd392',
    authDomain: 'noti-swd392.firebaseapp.com',
    storageBucket: 'noti-swd392.appspot.com',
  );
}
