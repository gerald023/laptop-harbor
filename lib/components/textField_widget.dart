import 'package:flutter/material.dart';

class TextfieldWidget extends StatefulWidget {
  final String? placeholder;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final bool disabled;
  final int? maxLines;

  const TextfieldWidget({
    super.key,
    this.placeholder,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.disabled = false,
    this.maxLines = 1,
  });

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controller,
            cursorColor: Colors.grey.shade800,
            keyboardType: widget.keyboardType,
            onTapOutside: (e) {
              FocusScope.of(context).unfocus();
            },
            validator: widget.validator,
            obscureText: widget.isPassword ? _obscureText : false,
            readOnly: widget.disabled,
            maxLines: widget.maxLines ?? 1,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              filled: true,
              fillColor: const Color(0xFFF5FCF9),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              hintText: widget.placeholder,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              suffixIcon: widget.isPassword
                  ? InkWell(
                      child: IconButton(
                        onPressed: _toggleObscureText,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility, // Toggle icons correctly
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : null,
            ),
          )
        ],
        
      ),
    );
  }
}
