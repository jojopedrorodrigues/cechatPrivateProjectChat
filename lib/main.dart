import 'dart:io';
import 'package:cechat/Views/Splash/SplashHome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
Future<InitializationStatus> _initGoogleMobileAds() {
    
    return MobileAds.instance.initialize();
  }

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? const FirebaseOptions(
            appId: "1:444433530506:android:259d93a1ef0de9cdf3b773",
            messagingSenderId: "444433530506",
            projectId: "cechataplicativo",
            apiKey: 'AIzaSyCzqvYVMSBSm_x-qbmLdI6I7edJ6jardpM',
          )
        : null,
  );
 // _initGoogleMobileAds();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  _initGoogleMobileAds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CeChat',
        theme: ThemeData(),
        home: const Splash());
  }
}
