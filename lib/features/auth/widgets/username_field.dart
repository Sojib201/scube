import 'package:flutter/material.dart';
import 'input_decoration.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: buildInputDecoration('Username'),
      keyboardType: TextInputType.text,
      validator: (value) => (value == null || value.isEmpty) ? 'Enter your username' : null,
    );
  }
}