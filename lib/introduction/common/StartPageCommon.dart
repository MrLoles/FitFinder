import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartPageScaffold extends StatelessWidget {
  final Widget child;

  StartPageScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.35), BlendMode.darken),
                image: AssetImage("assets/images/login-background.png"),
                fit: BoxFit.cover)),
        child: child,
      ),
    );
  }
}

class _NormalInputField extends StatelessWidget {
  final String inputName;
  final bool isPassword;
  final Icon icon;
  final TextEditingController controller;
  final FormFieldValidator validator;

  const _NormalInputField(
      {super.key,
      required this.inputName,
      this.isPassword = false,
      required this.icon,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          validator: validator,
          controller: controller,
          style: const TextStyle(fontSize: 12.0, color: Colors.white),
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: inputName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.65),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String inputName;
  final bool isPassword;
  final Icon icon;
  final TextEditingController controller;

  const InputField(
      {super.key,
      required this.inputName,
      this.isPassword = false,
      required this.icon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return _NormalInputField(
        key: key,
        inputName: inputName,
        isPassword: isPassword,
        icon: icon,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.validation;
          }
          return null;
        });
  }
}

class RegisterPassword extends StatelessWidget {
  final String inputName;
  final bool isPassword;
  final Icon icon;
  final TextEditingController controller;
  final TextEditingController passwordController;


  const RegisterPassword(
      {super.key,
        required this.inputName,
        this.isPassword = false,
        required this.icon,
        required this.controller,
        required this.passwordController});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return _NormalInputField(
        key: key,
        inputName: inputName,
        isPassword: isPassword,
        icon: icon,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localization.validation;
          }
          else if(value != passwordController.text){
            return localization.repeatPasswordValidation;
          }
          return null;
        });
  }
}