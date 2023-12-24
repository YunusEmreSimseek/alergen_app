// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mobilNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  Future<bool> registerUser(UserModel user) async {
    changeLoading();
    if (user.email == null || user.password == null) return false;
    final responseAuth =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
    if (responseAuth.user == null) return false;
    final response = await FirebaseCollections.user.reference.add(user.toJson());
    if (response.id.isEmpty) return false;
    emit(state.copyWith(isRedirect: true));
    changeLoading();
    return true;
  }

  void changeLoading() {
    emit(state.copyWith(isLoading: !state.isLoading));
  }
}

class RegisterState {
  final bool isRedirect;
  final bool isLoading;

  RegisterState({this.isRedirect = false, this.isLoading = false});

  RegisterState copyWith({
    bool? isRedirect,
    bool? isLoading,
  }) {
    return RegisterState(
      isRedirect: isRedirect ?? this.isRedirect,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
