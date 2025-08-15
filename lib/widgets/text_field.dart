import 'package:flutter/material.dart';

class STextField extends StatelessWidget {
  const STextField({super.key, this.controller, this.hintText, this.onChanged});

  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField();
  }
}