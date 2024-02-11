import 'package:alergen_app/feature/base/view/base_scaffold.dart';
import 'package:alergen_app/feature/login/cubit/login_cubit.dart';
import 'package:alergen_app/feature/register/view/register_view.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/widget/button/app_bar_dark_mode_icon_button.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class LoginVieww extends StatefulWidget {
  const LoginVieww({super.key});

  @override
  State<LoginVieww> createState() => _LoginViewwState();
}

class _LoginViewwState extends State<LoginVieww> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final Widget _navPage = const BaseScaffold();

  void chechUserAndNavigate({User? user, Widget? widget}) {
    context.read<LoginCubit>().fetchUserDetail(user);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && widget != null) {
        context.route.navigateToPage(widget);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => chechUserAndNavigate(user: _user, widget: _navPage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox.shrink(),
            actions: [
              Center(
                child: state.isLoading ? const CircularProgressIndicator() : const AppBarDarkModeIconButton(),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: context.padding.normal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TitleText(title: StringConstant.welcomeTitle),
                  context.sized.emptySizedHeightBoxLow3x,
                  _firebaseLoginView(),
                  context.sized.emptySizedHeightBoxLow3x,
                  _createAnAccountButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LoginView _firebaseLoginView() {
    return LoginView(
      action: AuthAction.signIn,
      showTitle: false,
      providers: FirebaseUIAuth.providersFor(
        FirebaseAuth.instance.app,
      ),
    );
  }

  TextButton _createAnAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await context.route.navigateToPage(const RegisterView());
      },
      child: const Text(
        StringConstant.loginCreateAnAccount,
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
