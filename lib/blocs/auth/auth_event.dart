part of 'auth_bloc.dart';

abstract class AuthEvent {}

class CheckLogin extends AuthEvent {}

class GoogleLogin extends AuthEvent {}

class GoogleLogout extends AuthEvent {}
