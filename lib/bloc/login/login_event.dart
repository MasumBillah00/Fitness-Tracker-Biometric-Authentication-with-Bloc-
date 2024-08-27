
// login_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final BuildContext context; // No longer needed if navigation is in BlocListener

  const LoginSubmitted(this.context);

  @override
  List<Object?> get props => [context];
}

class Logout extends LoginEvent {
  const Logout();  // No arguments needed
}

class ResetTimerEvent extends LoginEvent {}


// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
//
// abstract class LoginEvent extends Equatable {
//   const LoginEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class EmailChanged extends LoginEvent {
//   final String email;
//
//   const EmailChanged(this.email);
//
//   @override
//   List<Object> get props => [email];
// }
//
// class PasswordChanged extends LoginEvent {
//   final String password;
//
//   const PasswordChanged(this.password);
//
//   @override
//   List<Object> get props => [password];
// }
//
// class LoginSubmitted extends LoginEvent {
//   final BuildContext context;
//
//   const LoginSubmitted(this.context);
//
//   @override
//   List<Object> get props => [context];
// }
//
// class Logout extends LoginEvent {
//   final BuildContext context;
//
//   const Logout(this.context);
//
//   @override
//   List<Object> get props => [context];
// }
