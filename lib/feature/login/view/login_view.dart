import 'package:alergen_app/feature/base/view/base_scaffold.dart';
import 'package:alergen_app/feature/login/viewmodel/login_cubit.dart';
import 'package:alergen_app/feature/register/view/register_view.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  Widget navPage = const BaseScaffold();
  void chechkUser(User? user) {
    context.read<LoginCubit>().fetchUserDetail(user);
  }

  void chechUserAndNavigate({User? user, Widget? widget}) {
    chechkUser(user);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && widget != null) {
        context.route.navigateToPage(widget);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    chechUserAndNavigate(user: user, widget: navPage);
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
                child: state.isLoading ? const CircularProgressIndicator() : null,
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: context.padding.low,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _Header(),
                    Padding(
                      padding: context.padding.normal,
                      // firebasein base tasarim login sayfasini ekrana yazdirdik
                      child: LoginView(
                        action: AuthAction.signIn,
                        showTitle: false,
                        providers: FirebaseUIAuth.providersFor(
                          FirebaseAuth.instance.app,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await context.route.navigateToPage(const RegisterView());
                      },
                      child: const Text(
                        StringConstant.loginCreateAnAccount,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: StringConstant.welcomeTitle,
        ),
      ],
    );
  }
}
