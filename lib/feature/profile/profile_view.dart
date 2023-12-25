// ignore_for_file: use_build_context_synchronously

import 'package:alergen_app/feature/login/login_view.dart';
import 'package:alergen_app/feature/profile/profile_cubit.dart';
import 'package:alergen_app/main.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/button/profile_button.dart';
import 'package:alergen_app/product/widget/dialog/my_show_dialog.dart';
import 'package:alergen_app/product/widget/text/sub_title_text.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel user = UserModel();
  UserModel? updatedModel;
  final _profileLogic = ProfileLogic();

  Future<void> getUser() async {
    await context.read<ProfileCubit>().fetchUserDetails(FirebaseAuth.instance.currentUser);
    user = context.read<ProfileCubit>().state.user!;
    _profileLogic.addControllerToList(userModel: user);
  }

  @override
  void initState() {
    super.initState();
    resetState();
    Future.microtask(() => getUser());
  }

  void resetState() {
    context.read<ProfileCubit>().resetState();
  }

  Future<void> updateUser() async {
    UserModel newUser =
        user.copyWith(name: _profileLogic.nameController.text, surname: _profileLogic.surnameController.text);
    await context.read<ProfileCubit>().updateUser(newUser);
    MyShowDialog.userProfileUpdate(context);
    await context.read<ProfileCubit>().fetchUserDetails(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        final read = context.read<ProfileCubit>();
        if (state.user == null) {
          return const SizedBox.shrink();
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              title: TitleText(title: 'Profile ${state.user!.name}'),
              actions: [
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  BlocBuilder<Maincubit, bool>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            context.read<Maincubit>().changeIsDarkMode();
                          },
                          icon: state ? const Icon(Icons.dark_mode) : const Icon(Icons.dark_mode_outlined));
                    },
                  ),
                const _ExitToAppButton()
              ],
            ),
            body: Padding(
              padding: context.padding.normal,
              child: SafeArea(
                  child: Form(
                onChanged: () {
                  if (state.user!.name != _profileLogic.nameController.text ||
                      state.user!.surname != _profileLogic.surnameController.text) {
                    read.updateIsChanged(true);
                    updatedModel = user.copyWith();
                  } else if (state.user!.name == _profileLogic.nameController.text &&
                      state.user!.surname == _profileLogic.surnameController.text) {
                    read.updateIsChanged(false);
                  }
                },
                child: Padding(
                  padding: context.padding.low,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: context.padding.onlyBottomNormal,
                        child: const TitleText(title: StringConstant.profilePersonelInformation),
                      ),
                      GetInfo(userModel: state.user!, controllerList: _profileLogic.controllerList),
                      state.isChanged
                          ? ProfileButton(text: StringConstant.saveTitle, function: updateUser)
                          : const SizedBox.shrink(),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // ProfileButton(text: StringConstants.profileChangeEmail, function: () {}),
                          // ProfileButton(text: StringConstants.profileChangePassword, function: () {}),
                          // ProfileButton(text: StringConstants.profileChangeMobileNo, function: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        }
      },
    );
  }
}

class _ExitToAppButton extends StatelessWidget {
  const _ExitToAppButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const TitleText(title: StringConstant.dialogExitTitle),
                    content: const SubtitleText(title: StringConstant.dialogExitContent),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await FirebaseUIAuth.signOut(auth: FirebaseAuth.instance, context: context);
                            context.route.navigateToPage(const LoginVieww());
                          },
                          child: const Text(StringConstant.yesTitle)),
                      TextButton(
                          onPressed: () {
                            context.route.pop();
                          },
                          child: const Text(StringConstant.noTitle))
                    ],
                  ));
        },
        icon: const Icon(Icons.exit_to_app));
  }
}

class GetInfo extends StatelessWidget {
  GetInfo({super.key, required this.userModel, required this.controllerList});

  final UserModel userModel;
  final List<TextEditingController> controllerList;

  final List<String> liste = [
    'Name : ',
    'Surname : ',
    'Mobile No : ',
    'Email : ',
    'Password : ',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: context.padding.onlyBottomLow,
          child: SizedBox(
            height: context.sized.dynamicHeight(.45),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: context.padding.verticalLow,
                  child: TextFormField(
                      obscureText: index == 4 ? true : false,
                      controller: controllerList[index],
                      enabled: (index == 2 || index == 3 || index == 4) ? false : true,
                      decoration: InputDecoration(
                        prefixText: liste[index],
                        border: const OutlineInputBorder(),
                      )),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
