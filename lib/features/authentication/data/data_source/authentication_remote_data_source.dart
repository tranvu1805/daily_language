import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/core/utils/helper/method_utils.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<void> loginWithGoogle();

  Stream<UserModel?> getUser();

  Future<void> logout();
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthenticationRemoteDataSourceImpl({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
  }) : _googleSignIn = googleSignIn,
       _firebaseAuth = firebaseAuth;

  @override
  Stream<UserModel?> getUser() {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        username: firebaseUser.displayName,
        avatarUrl: firebaseUser.photoURL,
      );
    });
  }

  @override
  Future<void> loginWithGoogle() async {
    await _googleSignIn.initialize();
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user == null) {
      throwServerException(
        message: 'google sign-in failed',
        statusCode: 401,
      );
    }
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}
