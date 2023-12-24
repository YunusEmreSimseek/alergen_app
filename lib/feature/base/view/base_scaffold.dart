import 'package:alergen_app/feature/base/viewmodel/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../sub_view/base_bottom_nav_bar.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({super.key});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BaseCubit>(create: (contextHome) => BaseCubit()),
      ],
      child: BlocBuilder<BaseCubit, BaseState>(
        builder: (contextBuilderBottom, stateBuilderBottom) {
          final Widget page = contextBuilderBottom.read<BaseCubit>().decisionBody();
          return Scaffold(
            bottomNavigationBar: const BottomNavBar(),
            body: page,
          );
        },
      ),
    );
  }
}
