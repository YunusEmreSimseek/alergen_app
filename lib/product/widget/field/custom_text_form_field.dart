import 'package:alergen_app/product/utility/extension/validation_extension.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      this.hintText,
      required this.controller,
      this.keyboardtype,
      this.isPassword,
      this.validator,
      this.validationType});
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardtype;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final String? validationType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        switch (widget.validationType?.toLowerCase()) {
          case 'name':
            if (value!.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          case 'surname':
            if (value!.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          case 'number':
            if (!value!.isValidPhone) {
              return 'Enter valid number';
            }
            return null;
          case 'email':
            if (!value!.isValidEmail) {
              return 'Enter valid email';
            }
            return null;
          case 'password':
            if (!value!.isPasswordValid) {
              return 'your password must be 8-16 characters, and include at least one lowercase letter, one uppercase letter, and a number';
            }
            return null;
          default:
        }
        return null;
      },
      controller: widget.controller,
      keyboardType: widget.keyboardtype ?? TextInputType.text,
      obscureText: widget.isPassword ?? false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.hintText,
      ),
    );
  }
}

class GetterFormField extends StatefulWidget {
  const GetterFormField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<GetterFormField> createState() => _GetterFormFieldState();
}

class _GetterFormFieldState extends State<GetterFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(.8),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: context.padding.low,
            child: TextFormField(
              initialValue: 'ad',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          );
        },
      ),
    );
  }
}
