import 'package:alergen_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarDarkModeIconButton extends StatelessWidget {
  const AppBarDarkModeIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Maincubit, bool>(
      builder: (context, state) {
        return IconButton(
            onPressed: () {
              context.read<Maincubit>().changeIsDarkMode();
            },
            icon: state ? const Icon(Icons.dark_mode) : const Icon(Icons.dark_mode_outlined));
      },
    );
  }
}
