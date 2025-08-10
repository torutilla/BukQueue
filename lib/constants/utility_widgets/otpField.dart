import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class FieldOTPUtil extends StatefulWidget {
  final double fieldWidth;
  final double fieldHeight;
  final Function(String? input) callBack;
  const FieldOTPUtil({
    super.key,
    required this.fieldWidth,
    this.fieldHeight = 40,
    required this.callBack,
  });

  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<FieldOTPUtil> {
  final int _otpLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  late Color _borderColor;
  @override
  void initState() {
    super.initState();
    _borderColor = primaryColor;
    for (int i = 0; i < _otpLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < _otpLength; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  String get _otpValue {
    return _controllers.map((controller) => controller.text).join();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
    widget.callBack(_otpValue);
    validateField();
  }

  void validateField() {
    setState(() {
      _borderColor = _otpValue.isEmpty ? invalidInput : secondaryColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _otpLength,
        (index) {
          return Container(
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TextField(
              cursorColor: _borderColor,
              textAlignVertical: TextAlignVertical.center,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              onChanged: (value) => _handleInput(value, index),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor)),
                counterText: '',
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: _borderColor, style: BorderStyle.solid),
                ),
              ),
            ),
          );
        },
        growable: false,
      ),
    );
  }
}
