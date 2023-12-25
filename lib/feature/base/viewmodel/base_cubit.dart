// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alergen_app/feature/alergen/alergen_view.dart';
import 'package:alergen_app/feature/home/home_view.dart';
import 'package:alergen_app/feature/login/login_view.dart';
import 'package:alergen_app/feature/profile/profile_view.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/enum/widget_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState(currentIndex: 0));

  void changeCurrentIndex(int value) {
    emit(state.copyWith(currentIndex: value));
  }

  Widget decisionBody() {
    switch (state.currentIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const AlergenView();
      case 2:
        return const ProfileView();
    }
    return const LoginVieww();
  }

  String decisionAppbarText() {
    switch (state.currentIndex) {
      case 0:
        return StringConstant.loginCreateAnAccount;
      case 1:
        return StringConstant.profilePersonelInformation;
      case 2:
        return StringConstant.registerWelcome;
    }
    return StringConstant.loginCreateAnAccount;
  }
}

class BaseState {
  BaseState({required this.currentIndex});

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.home,
          size: WidgetSize.iconNormal.value,
        ),
        label: StringConstant.homeTitle),
    BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.heart_slash,
          size: WidgetSize.iconNormal.value,
        ),
        label: StringConstant.alergenTitle),
    BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.profile_circled,
          size: WidgetSize.iconNormal.value,
        ),
        label: StringConstant.profileTitle),
  ];

  final int currentIndex;

  BaseState copyWith({
    int? currentIndex,
  }) {
    return BaseState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}





// class BottomNavBarStates extends BaseStates {
//   BottomNavBarStates({required this.currentIndex});

//   final List<BottomNavigationBarItem> items = [
//     const BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: StringConstant.loginCreateAnAccount),
//     const BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: StringConstant.profilePersonelInformation),
//     const BottomNavigationBarItem(icon: Icon(CupertinoIcons.bag), label: StringConstant.registerWelcome),
//   ];
//   final int currentIndex;

//   BottomNavBarStates copyWith({int? currentIndex}) {
//     return BottomNavBarStates(
//       currentIndex: currentIndex ?? this.currentIndex,
//     );
//   }
// }


