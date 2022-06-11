import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';

class InputField extends StatelessWidget {
  final TextEditingController inputController;

  final String? label;
  final String? hint;
  final IconData? icon;
  final bool isPassword;
  final bool isEmail;

  const InputField(
      {Key? key,
      required this.inputController,
      this.label,
      this.hint,
      this.icon,
      this.isEmail = false,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 14.0),
        prefixIcon: Icon(icon, color: primaryAccentColor),
        hintText: hint,
        hintStyle: const TextStyle(
          color: shadeColor,
        ));

    const labelStyle = TextStyle(
      color: tertiaryColor,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );

    final textField = TextField(
        controller: inputController,
        keyboardType: isEmail ? TextInputType.emailAddress : null,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: inputDecoration);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label!,
          style: labelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: textField,
        ),
      ],
    );
  }
}
