/*

Mange auth states

*/

import 'package:together/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

// initail
class AuthInitial extends AuthState {}

// loading..
class AuthLoading extends AuthState {}

//authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

//unauthenticated
class UnAuthenticated extends AuthState {}

//errors
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
