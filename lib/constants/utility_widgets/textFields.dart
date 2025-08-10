import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class TextFieldFormat extends StatefulWidget {
  final String formText;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final double fieldWidth;
  final double fieldHeight;
  final double borderRadius;
  final Color backgroundColor;
  final bool enableObscure;
  final bool enableTrailingButton;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color textColor;
  final BorderRadius? customBorderRadius;
  final String? hintText;
  final Widget? customPrefix;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final Function(String value)? onFieldSubmit;
  final int maxLines;
  final bool enabled;
  final Color disabledColor;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool enableCustomHeight;
  final void Function()? editingComplete;
  final TextInputAction? textInputAction;
  final void Function(PointerDownEvent)? onTapOutside;
  const TextFieldFormat({
    super.key,
    this.formText = '',
    required this.controller,
    this.prefixIcon,
    this.fieldWidth = 0,
    this.fieldHeight = 0,
    this.borderRadius = 0,
    this.backgroundColor = Colors.transparent,
    this.enableObscure = false,
    this.validator,
    this.enableTrailingButton = false,
    this.borderColor = primaryColor,
    this.focusedBorderColor = secondaryColor,
    this.textColor = Colors.black,
    this.customBorderRadius,
    this.hintText,
    this.customPrefix,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onFieldSubmit,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.disabledColor = grayColor,
    this.enableCustomHeight = false,
    this.editingComplete,
    this.textInputAction,
    this.onTapOutside,
  });

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldFormat> {
  late Color _borderColor;
  bool _isPasswordVisible = true;

  @override
  void initState() {
    _borderColor = widget.borderColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: widget.enableCustomHeight ? widget.fieldHeight : null,
        width: widget.fieldWidth <= 350 ? widget.fieldWidth : 350,
        child: Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: widget.focusedBorderColor.withOpacity(0.5),
              cursorColor: widget.borderColor,
            ),
          ),
          child: TextFormField(
            onTapOutside: widget.onTapOutside,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            onFieldSubmitted: widget.onFieldSubmit,
            focusNode: widget.focusNode,
            textCapitalization: widget.textCapitalization,
            keyboardType: widget.textInputType,
            style: TextStyle(color: widget.textColor),
            obscureText:
                _passwordField() ? _isPasswordVisible : !_isPasswordVisible,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.disabledColor)),
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              hintText: widget.hintText ?? widget.hintText,
              hintStyle:
                  TextStyle(color: grayInputBox, fontWeight: FontWeight.w400),
              fillColor: widget.backgroundColor,
              filled:
                  widget.backgroundColor != Colors.transparent ? true : false,
              prefixIcon: widget.customPrefix ?? widget.prefixIcon,
              suffixIcon: widget.enableObscure
                  ? IconButton(
                      icon: Icon(
                        !_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: widget.borderColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : widget.suffixIcon,
              prefixIconColor: widget.borderColor,
              label: widget.hintText == null ? Text(widget.formText) : null,
              labelStyle: TextStyle(
                  color: widget.borderColor,
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis),
              border: OutlineInputBorder(
                borderRadius: widget.customBorderRadius == null
                    ? BorderRadius.circular(widget.borderRadius)
                    : widget.customBorderRadius!,
                borderSide:
                    BorderSide(color: _borderColor, style: BorderStyle.solid),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.customBorderRadius == null
                    ? BorderRadius.circular(widget.borderRadius)
                    : widget.customBorderRadius!,
                borderSide:
                    BorderSide(color: _borderColor, style: BorderStyle.solid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.customBorderRadius == null
                    ? BorderRadius.circular(widget.borderRadius)
                    : widget.customBorderRadius!,
                borderSide: BorderSide(
                    color: widget.focusedBorderColor, style: BorderStyle.solid),
              ),
            ),
            controller: widget.controller,
            onEditingComplete: () {
              _borderColor = secondaryColor;
              if (widget.editingComplete != null) {
                widget.editingComplete;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onChanged: (text) {
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
              final selection = widget.controller.selection;
              widget.controller.text = text;
              widget.controller.selection = selection;
            },
          ),
        ),
      ),
    );
  }

  bool _passwordField() {
    if (widget.formText == "Password" ||
        widget.hintText == "Password" ||
        widget.formText == "Confirm Password") {
      return true;
    }
    return false;
  }
}
