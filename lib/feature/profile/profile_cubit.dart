import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  Future<UserModel?> fetchUserDetails(User? user) async {
    if (user == null) return null;
    final response = await FirebaseCollections.user.reference
        .where('email', isEqualTo: user.email)
        .withConverter(
          fromFirestore: (snapshot, options) => UserModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final user = response.docs.single.data();
      emit(state.copyWith(user: user));
      return user;
    }
    return null;
  }

  void updateIsChanged(bool value) {
    emit(state.copyWith(isChanged: value));
  }

  void changeLoading() {
    emit(state.copyWith(isLoading: !state.isLoading));
  }

  void changeIsDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void resetState() {
    emit(const ProfileState());
  }

  Future<void> updateUser(UserModel model) async {
    changeLoading();
    if (model.id!.isEmpty) return;
    await FirebaseCollections.user.reference.doc(model.id).set({
      "name": model.name,
      "surname": model.surname,
      "mobileNo": model.mobileNo,
      "email": model.email,
      "password": model.password,
    });
    changeLoading();
  }
}

class ProfileState {
  const ProfileState({this.user, this.isChanged = false, this.isLoading = false, this.isDarkMode = false});
  final UserModel? user;
  final bool isChanged;
  final bool isLoading;
  final bool isDarkMode;

  ProfileState copyWith({UserModel? user, bool? isChanged, bool? isLoading, bool? isDarkMode}) {
    return ProfileState(
      user: user ?? this.user,
      isChanged: isChanged ?? this.isChanged,
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class ProfileLogic {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController mobilNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<TextEditingController> controllerList = [];

  void addControllerToList({required UserModel userModel}) {
    nameController.text = userModel.name ?? '';
    surnameController.text = userModel.surname ?? '';
    mobilNoController.text = userModel.mobileNo ?? '';
    emailController.text = userModel.email ?? '';
    passwordController.text = userModel.password ?? '';

    controllerList.add(nameController);
    controllerList.add(surnameController);
    controllerList.add(mobilNoController);
    controllerList.add(emailController);
    controllerList.add(passwordController);
  }
}
