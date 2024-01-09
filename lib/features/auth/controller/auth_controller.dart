/// This auth controller class is responsible for handling all the communications between
/// auth repositiorty class and the sign in page (UI).
/// Any data comes from the auth repository will be handled by the controller.
/// This way it is more easy to do unit testing.
///
/// We are not going to call the controller with a class instance,
/// becasue then the controller gets called every time the screen builds.
///
/// We are using Riverpod provider to use controllers
///
/// Providers can't be inside a class, it has to be global.
/// Provider ref help us access the other providers and give us buch of methods
/// to talk to other providers.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import '../../../models/user_model.dart';

// Here we are going to use StateProvider because we need to change the value
// of the userProvider
final userProvider = StateProvider<UserModel?>((ref) => null);

// So now here we are watching the authRepositoryProvider for any changes
// we are specifing the type of StateNotifierProvider to <AuthController, bool>
// bool will be used to identify if the page is loading or not
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

// Creating a provider for authStateChange Stream inside auth repository
final authStateChangeProvider = StreamProvider((ref) {
  // instance of AuthController Provider Class
  // we don't have direct access to authcontroller, as this is a type of boolean
// inorder to access it we need to use notifier
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// Ceating a stream provider for getUserData
// inorder to access the uid, extend the streamProvider with family then we can pass downa variable
// in the parameter
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// we are extending AuthController class using stateNotifier
// by using stateNotifier we donot need an another listener as the
// stateNotifier will take of it .
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        //super represents the loading part of the state
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    // By using fold we can access error handling
    // from inside auth_controller
    // l(left) - failiure, r(right) - success
    // showSnackBar is coming from utils.dart
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

// Creating a provider for getUserData from authRepository
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
