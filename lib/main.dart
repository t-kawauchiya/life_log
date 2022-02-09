import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_sample/auth/sign_up_page.dart';
import 'app_page/app_page.dart';
import 'auth/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'loginSample',
      home: SignInPage(),
      builder: EasyLoading.init(),
      routes: {
        '/signIn': (context) => SignInPage(),
        '/signUp': (context) => const SignUpPage(),
        '/app': (context) => const AppPage(),
      },
    );
  }
}
