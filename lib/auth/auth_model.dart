import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_sample/firebase_auth_exception_handler.dart';

class AuthModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final firebaseInstance = FirebaseAuth.instance;

  Future<void> signOut() async {
    firebaseInstance.signOut();
  }

  Future<FirebaseAuthResultStatus> signUpWithEmailAndPassword() async {
    FirebaseAuthResultStatus result = FirebaseAuthResultStatus.undefined;
    if (_email != '' && _password != '') {
      try {
        final user = (await firebaseInstance.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (user != null) {
          result = FirebaseAuthResultStatus.successful;
          final uid = user.uid;
          // add user to firestore
          final doc = FirebaseFirestore.instance.collection('users').doc(uid);
          await doc.set(
            {
              'uid': uid,
              'email': _email,
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        result = FirebaseAuthExceptionHandler.handleException(e);
      }
    }
    return result;
  }

  Future<FirebaseAuthResultStatus> signInWithEmailAndPassword() async {
    FirebaseAuthResultStatus result = FirebaseAuthResultStatus.undefined;
    try {
      final user = (await firebaseInstance.signInWithEmailAndPassword(
              email: _email, password: _password))
          .user;
      if (user != null) {
        final doc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await doc.update(
          {
            'latestLoginTime': DateTime.now(),
          },
        );
        result = FirebaseAuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      result = FirebaseAuthExceptionHandler.handleException(e);
    }
    return result;
  }

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  set isPasswordVisible(bool isPasswordVisible) {
    _isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
