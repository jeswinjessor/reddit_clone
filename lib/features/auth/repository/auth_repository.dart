/// This auth repository Class is handling all the authentication backend code
/// this repository will communicate with the controller and the controller will communicate
/// with the login screen (UI).
///
/// We are not going to call the repository with a class instance,
/// becasue then the repository gets called every time the screen builds.
/// We are using Riverpod provider to use repository
/// Providers can't be inside a class, it has to be global.
/// We are using provider for fireabse as well

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/models/user_model.dart';

/// Here we are reading providers from firebase_providers to pass data
/// to the authRepositoryProvider

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  void signInWithGoogle() async {
    try {
      // SignIn with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? 'No Name',
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []);

        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      }
      // Save Data to Firestore
    } catch (E) {}
  }
}
