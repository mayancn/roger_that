import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roger_that/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is CheckLogin) {
      if (await checkLoginStatus()) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnAuthenticated();
      }
    }

    if (event is GoogleLogin) {
      if (await googleLogin()) {
        UserModel _user = UserModel(email: user.email, photo: user.photoUrl);
        _user.createUser();
        yield AuthAuthenticated();
      } else {
        yield AuthUnAuthenticated();
      }
    }

    if (event is GoogleLogout) {
      if (await googleLogout()) yield AuthUnAuthenticated();
    }
  }
}
