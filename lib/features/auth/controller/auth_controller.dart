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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

// So now here we are reading the authRepositoryProvider

final authControllerProvider = Provider(
    (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle() {
    _authRepository.signInWithGoogle();
  }
}
