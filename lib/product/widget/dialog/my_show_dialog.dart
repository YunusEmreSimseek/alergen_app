import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/widget/text/sub_title_text.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

@immutable
class MyShowDialog {
  const MyShowDialog._();
  static Future<dynamic> userRegister(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: TitleText(title: StringConstant.dialogUserRegisterTitle),
              content: SubtitleText(title: StringConstant.dialogUserRegisterContent),
              actions: [],
            ));
  }

  static Future<dynamic> userProfileUpdate(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const TitleText(title: StringConstant.dialogProfileUpdateTitle),
              content: const SubtitleText(title: StringConstant.dialogProfileUpdateContent),
              actions: [TextButton(onPressed: () => context.route.pop(), child: const Text(StringConstant.okTitle))],
            ));
  }

  static Future<dynamic> alergenAddingSucces(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const TitleText(title: StringConstant.dialogAlergenAddingSuccesTitle),
              content: const SubtitleText(title: StringConstant.dialogAlergenAddingSuccesContent),
              actions: [TextButton(onPressed: () => context.route.pop(), child: const Text(StringConstant.okTitle))],
            ));
  }

  static Future<dynamic> alergenAddingFailed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const TitleText(title: StringConstant.dialogAlergenAddingFailedTitle),
              content: const SubtitleText(title: StringConstant.dialogAlergenAddingFailedContent),
              actions: [TextButton(onPressed: () => context.route.pop(), child: const Text(StringConstant.okTitle))],
            ));
  }

  static Future<dynamic> alergenRemovedSucces(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const TitleText(title: StringConstant.alergenRemovedSuccesTitle),
              content: const SubtitleText(title: StringConstant.alergenRemovedSuccesContent),
              actions: [TextButton(onPressed: () => context.route.pop(), child: const Text(StringConstant.okTitle))],
            ));
  }
}
