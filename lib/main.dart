import 'package:alergen_app/feature/alergen/viewmodel/alergen_cubit.dart';
import 'package:alergen_app/feature/home/viewmodel/home_cubit.dart';
import 'package:alergen_app/feature/login/view/login_view.dart';
import 'package:alergen_app/feature/login/viewmodel/login_cubit.dart';
import 'package:alergen_app/feature/profile/view_model/profile_cubit.dart';
import 'package:alergen_app/product/init/app_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await AppStart.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<AlergenCubit>(create: (context) => AlergenCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        home: const LoginVieww(),
      ),
    );
  }
}
