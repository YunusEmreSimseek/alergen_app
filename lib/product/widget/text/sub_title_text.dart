import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.general.textTheme.titleMedium?.copyWith(),
    );
  }
}
