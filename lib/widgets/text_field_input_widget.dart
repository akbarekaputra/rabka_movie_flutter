import 'package:flutter/material.dart';

class TextFieldInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInputWidget({
    super.key,
    required this.textEditingController,
    this.isPassword = false,
    required this.hintText,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
      ),
      filled: true,
      contentPadding: const EdgeInsets.all(8),
    );

    return TextField(
      controller: textEditingController,
      decoration: inputDecoration,
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
