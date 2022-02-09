import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_sample/app_page/app_page_model.dart';
import 'package:login_sample/auth/auth_model.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

final userProvider = ChangeNotifierProvider((ref) => AuthModel());
final appPageProvider = ChangeNotifierProvider((ref) => AppPageModel());
User? _currentUser = FirebaseAuth.instance.currentUser;

class AppPage extends ConsumerWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const _pageList = [
      FirstPage(),
      SecondPage(),
      ThirdPage(),
    ];

    return Consumer(
      builder: (context, watch, child) {
        final userModel = ref.watch(userProvider);
        final appPageModel = ref.watch(appPageProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('login sample'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () async {
                  userModel.signOut();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: _pageList[appPageModel.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appPageModel.currentIndex,
            elevation: 15,
            onTap: (index) {
              appPageModel.currentIndex = index;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                  tooltip: "go to home page"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'business',
                  tooltip: 'go to business page'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'school',
                  tooltip: 'go to school page'),
            ],
          ),
        );
      },
    );
  }
}
