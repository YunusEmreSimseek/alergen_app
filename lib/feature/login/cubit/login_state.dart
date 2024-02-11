part of 'login_cubit.dart';

final class LoginState {
  LoginState({this.isRedirect = false, this.isLoading = false});

  final bool isRedirect;
  final bool isLoading;

  LoginState copyWith({
    bool? isRedirect,
    bool? isLoading,
  }) {
    return LoginState(
      isRedirect: isRedirect ?? this.isRedirect,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
