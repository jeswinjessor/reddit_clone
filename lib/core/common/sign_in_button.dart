/// This page is resposponsible for handling the signin Button.
/// The reson why we have login button in a seperate file is to sepereate business logic of
/// letting the user signin before they communicate with the community,
/// as there might be a chance that the user could skip the signin part if they like to.
///
///
/// This sign_in_button widget will communicate with the authController to let the user signin.
/// This way we can use this signIn button anywhere in the widget
/// and the providers, controllers and repository will take care of the rest.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  // I have changed the Stateless widget to ConsumerWidget, which enable us to
  // listen to provider and make changes to the widget accordingly.
  const SignInButton({Key? key}) : super(key: key);

  // Good Practice: have a separate function for the signIn to use it inside OnPressed,
  // In future if we desided to change the style of the button we can do it by simply
  // deleting the whole code present below without rewriting the actual function.

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
          icon: Image.asset(
            Constants.googlePath,
            width: 35,
          ),
          label: const Text(
            'Continue with Google',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Pallete.greyColor,
              minimumSize: const Size(double.infinity, 50))),
    );
  }
}
