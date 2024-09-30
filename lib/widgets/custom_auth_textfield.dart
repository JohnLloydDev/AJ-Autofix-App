import 'package:flutter/material.dart';

class CustomAuthTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData suffixIcon;
  final bool isPasswordField;
  final bool isPasswordVisible;
  final VoidCallback? togglePasswordVisibility;

  const CustomAuthTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.suffixIcon,
    this.isPasswordField = false,
    this.isPasswordVisible = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.05),
          child: TextField(
            controller: controller,
            obscureText: isPasswordField && !isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              hintText: hintText,
              suffixIcon: isPasswordField
                  ? IconButton(
                      onPressed: togglePasswordVisibility,
                      icon: isPasswordVisible
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    )
                  : Icon(suffixIcon),
            ),
          ),
        ),
      ),
    );
  }
}
