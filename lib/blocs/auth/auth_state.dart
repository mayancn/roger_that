part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}
