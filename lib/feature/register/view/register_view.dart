import 'package:alergen_app/feature/register/cubit/register_cubit.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/dialog/my_show_dialog.dart';
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
                key: read.formKey,
                onChanged: () {},
                child: SafeArea(
                  child: ListView(
                    padding: context.padding.normal,
                    children: [
                      const Center(child: TitleText(title: StringConstant.welcomeTitle)),
                      context.sized.emptySizedHeightBoxLow3x,
                      _nameFormField(read),
                      context.sized.emptySizedHeightBoxLow3x,
                      _surnameFormField(read),
                      context.sized.emptySizedHeightBoxLow3x,
                      _mobileFormField(read),
                      context.sized.emptySizedHeightBoxLow3x,
                      _emailFormField(read),
                      context.sized.emptySizedHeightBoxLow3x,
                      _passwordFormField(read),
                      context.sized.emptySizedHeightBoxLow3x,
                      _saveButton(read, state, context)
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  CustomTextFormField _passwordFormField(RegisterCubit read) {
    return CustomTextFormField(
      controller: read.passwordController,
      hintText: StringConstant.registerPasswordTitle,
      keyboardtype: TextInputType.visiblePassword,
      isPassword: true,
      validationType: StringConstant.validationPassword,
    );
  }

  CustomTextFormField _emailFormField(RegisterCubit read) {
    return CustomTextFormField(
      controller: read.emailController,
      hintText: StringConstant.registerEmailTitle,
      keyboardtype: TextInputType.emailAddress,
      validationType: StringConstant.validationEmail,
    );
  }

  CustomTextFormField _mobileFormField(RegisterCubit read) {
    return CustomTextFormField(
      controller: read.mobilNoController,
      hintText: StringConstant.registerMobilNoTitle,
      keyboardtype: TextInputType.number,
      validationType: StringConstant.validationNumber,
    );
  }

  CustomTextFormField _surnameFormField(RegisterCubit read) {
    return CustomTextFormField(
      controller: read.surnameController,
      hintText: StringConstant.registerSurnameTitle,
      keyboardtype: TextInputType.name,
      validationType: StringConstant.validationSurname,
    );
  }

  CustomTextFormField _nameFormField(RegisterCubit read) {
    return CustomTextFormField(
      controller: read.nameController,
      hintText: StringConstant.registerNameTitle,
      keyboardtype: TextInputType.name,
      validationType: StringConstant.validationName,
    );
  }

  ElevatedButton _saveButton(RegisterCubit read, RegisterState state, BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (read.formKey.currentState!.validate()) {
            UserModel user = UserModel(
              email: read.emailController.text,
              mobileNo: read.mobilNoController.text,
              name: read.nameController.text,
              password: read.passwordController.text,
              surname: read.surnameController.text,
            );
            MyShowDialog.userRegister(context);
            Future.delayed(const Duration(seconds: 3), () => context.route.pop());
            await read.registerUser(user);
          }
        },
        child: const Text(StringConstant.registerSave));
  }
}
