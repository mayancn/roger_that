part of 'auth_bloc.dart';

FirebaseUser user;

Future<bool> checkLoginStatus() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  user = await firebaseAuth.currentUser();
  return user.runtimeType == FirebaseUser;
}

Future<bool> googleLogin() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
  final AuthCredential _credential = GoogleAuthProvider.getCredential(accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);

  user = (await _auth.signInWithCredential(_credential)).user;
  if (user.runtimeType == FirebaseUser) return true;

  return false;
}

Future<bool> googleLogout() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  _googleSignIn.signOut();
  return true;
}
