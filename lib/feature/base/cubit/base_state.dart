part of 'base_cubit.dart';

final class BaseState {
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
