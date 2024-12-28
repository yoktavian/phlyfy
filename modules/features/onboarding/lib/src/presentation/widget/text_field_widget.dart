import 'package:flutter/material.dart';

/// just a basic text field component with a custom design.
/// property that we can set:
/// 1. key (optional)
/// 2. placeholder (optional)
/// 3. placeholder color (optional)
/// 4. text color (optional)
/// 5. onChanged (optional)
/// 6. onSubmitted (optional)
class TextFieldWidget extends StatelessWidget {
  final String placeholder;
  final Color textColor;
  final Color placeholderColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const TextFieldWidget({
    super.key,
    this.textColor = Colors.black54,
    this.placeholderColor = Colors.black38,
    this.placeholder = '',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.redAccent),
    );

    return TextFormField(
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        hintText: placeholder,
        hintStyle: TextStyle(color: placeholderColor),
        prefixIcon: Icon(Icons.search, color: textColor),
      ),
      cursorColor: Colors.white,
      textInputAction: TextInputAction.go,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}
