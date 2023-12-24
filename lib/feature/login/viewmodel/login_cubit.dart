// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alergen_app/product/enum/cache_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<void> fetchUserDetail(User? user) async {
    if (user == null) return;
    // giris yapan userin tokenini aldik
    final token = await user.getIdToken();
    tokenSaveToCache(token!);
    // statei guncelledik
    emit(state.copyWith(isRedirect: true));
  }

  Future<void> tokenSaveToCache(String token) async {
    await CacheItems.token.write(token);
  }
}

class LoginState {
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
