part of 'profile_cubit.dart';

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
