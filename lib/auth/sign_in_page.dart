import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_sample/app_page/app_page.dart';
import 'package:login_sample/auth/sign_up_page.dart';
import 'package:login_sample/auth/auth_model.dart';
import 'package:login_sample/firebase_auth_exception_handler.dart';

final userProvider = ChangeNotifierProvider(
  (ref) => AuthModel(),
);

class SignInPage extends ConsumerWidget {
  SignInPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, watch, child) {
        final userModel = ref.watch(userProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('sign in'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: userModel.emailController,
                      validator: (value) {
                        if (value!.isEmpty) '値が未設定です。';
                      },
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (text) => userModel.email = text,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: userModel.passwordController,
                      obscureText: userModel.isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) '値が未設定です。';
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            userModel.isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => userModel.isPasswordVisible =
                              !userModel.isPasswordVisible,
                        ),
                      ),
                      onChanged: (text) => userModel.password = text,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _signInButtonAction(context, ref);
                        }
                      },
                      child: const Text('sign in'),
                    ),
                    TextButton(
                      onPressed: () async {
                        _toSignUpButtonAction(context, ref);
                      },
                      child: const Text('to sign up'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future _signInButtonAction(BuildContext context, WidgetRef ref) async {
    EasyLoading.show(status: 'Loading...');
    final userModel = ref.watch(userProvider);
    final FirebaseAuthResultStatus result =
        await userModel.signInWithEmailAndPassword();
    if (FirebaseAuthResultStatus.successful == result) {
      Navigator.pushNamed(context, '/app');
    } else {
      final snackBar = SnackBar(
        content: Text(FirebaseAuthExceptionHandler.exceptionMessage(result)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    EasyLoading.dismiss();
  }

  Future _toSignUpButtonAction(BuildContext context, WidgetRef ref) async {
    try {
      await Navigator.pushNamed(context, '/signUp');
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
