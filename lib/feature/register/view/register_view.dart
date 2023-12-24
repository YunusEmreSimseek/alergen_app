import 'package:alergen_app/feature/home/view/home_view.dart';
import 'package:alergen_app/feature/register/view_model/register_cubit.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/field/custom_text_form_field.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) ? 'Enter a valid email address' : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final read = context.read<RegisterCubit>();
          return Scaffold(
              appBar: AppBar(actions: [
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ]),
              body: Form(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                key: read.formKey,
                onChanged: () {},
                child: SafeArea(
                  child: ListView(
                    padding: context.padding.normal,
                    children: [
                      const Center(child: TitleText(title: StringConstant.welcomeTitle)),
                      Padding(
                        padding: context.padding.verticalNormal,
                        child: CustomTextFormField(
                          controller: read.nameController,
                          hintText: StringConstant.registerNameTitle,
                          keyboardtype: TextInputType.name,
                          validationType: StringConstant.validationName,
                        ),
                      ),
                      CustomTextFormField(
                        controller: read.surnameController,
                        hintText: StringConstant.registerSurnameTitle,
                        keyboardtype: TextInputType.name,
                        validationType: StringConstant.validationSurname,
                      ),
                      Padding(
                        padding: context.padding.verticalNormal,
                        child: CustomTextFormField(
                          controller: read.mobilNoController,
                          hintText: StringConstant.registerMobilNoTitle,
                          keyboardtype: TextInputType.number,
                          validationType: StringConstant.validationNumber,
                        ),
                      ),
                      CustomTextFormField(
                        controller: read.emailController,
                        hintText: StringConstant.registerEmailTitle,
                        keyboardtype: TextInputType.emailAddress,
                        // validator: validateEmail,
                        validationType: StringConstant.validationEmail,
                      ),
                      Padding(
                        padding: context.padding.verticalNormal,
                        child: CustomTextFormField(
                          controller: read.passwordController,
                          hintText: StringConstant.registerPasswordTitle,
                          keyboardtype: TextInputType.visiblePassword,
                          isPassword: true,
                          validationType: StringConstant.validationPassword,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (read.formKey.currentState!.validate()) {
                              UserModel user = UserModel(
                                email: read.emailController.text,
                                mobileNo: read.mobilNoController.text,
                                name: read.nameController.text,
                                password: read.passwordController.text,
                                surname: read.surnameController.text,
                              );

                              await read.registerUser(user);
                              if (state.isRedirect) {
                                await context.route.navigateToPage(const HomeView());
                              }
                              // if (_registerNotifier.emailController.text) {}
                            }
                          },
                          child: const Text(StringConstant.registerSave))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
