import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignInWidget extends StatelessWidget {
  final bool obscureText;
  TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final String labelText;
  final Icon prefixIcon;
  IconButton? suffixIcon;
  final String? Function(String?)? validator;

  SignInWidget({
    super.key,
    required this.obscureText,
    this.keyboardType,
    required this.onChanged,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 119, 78, 40),
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 137, 59, 3),
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
