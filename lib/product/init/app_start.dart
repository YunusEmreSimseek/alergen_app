import 'package:alergen_app/firebase_options.dart';
import 'package:alergen_app/product/init/app_cache.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

@immutable
class AppStart {
  const AppStart._();
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DeviceUtility.instance.initPackageInfo();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // firebase auth gerekliliklerini buraya ekliyoruz
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
      //GoogleProvider(clientId: ''),
    ]);

    // SharedPreferences setup yapiyoruz
    await AppCache.instance.setup();
  }
}
