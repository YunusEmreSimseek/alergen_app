part of 'register_cubit.dart';

final class RegisterState {
  final bool isLoading;

  RegisterState({this.isLoading = false});

  RegisterState copyWith({
    bool? isRedirect,
    bool? isLoading,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
