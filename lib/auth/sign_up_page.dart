import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_sample/auth/auth_model.dart';
import 'package:login_sample/firebase_auth_exception_handler.dart';

final userProvider = ChangeNotifierProvider(
  (ref) => AuthModel(),
);

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, watch, child) {
        final userModel = ref.watch(userProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('sign up'),
          ),
          body: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: userModel.emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          userModel.email = text;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: userModel.passwordController,
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                        onChanged: (text) {
                          userModel.password = text;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          _signUpButtonAction(context, ref);
                        },
                        child: const Text('sign up'),
                      )
                    ],
                  ),
                ),
                if (userModel.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _signUpButtonAction(BuildContext context, WidgetRef ref) async {
    final _userModel = ref.watch(userProvider);
    _userModel.startLoading();
    final result = await _userModel.signUpWithEmailAndPassword();
    if (result == FirebaseAuthResultStatus.successful) {
      Navigator.of(context).pop();
    } else {
      final snackBar = SnackBar(
        content: Text(FirebaseAuthExceptionHandler.exceptionMessage(result)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    _userModel.endLoading();
  }
}
