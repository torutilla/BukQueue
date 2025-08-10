import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class NumberInputField extends StatefulWidget {
  final int maxNum;
  final void Function()? callBack;
  final Color? backgroundColor;
  final double borderRadius;
  final double paddingAmount;
  final double width;
  final double height;
  final void Function(String value)? valueCallback;
  const NumberInputField({
    super.key,
    this.maxNum = 3,
    this.callBack,
    this.backgroundColor,
    this.borderRadius = 0,
    this.paddingAmount = 0,
    required this.width,
    required this.height,
    this.valueCallback,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  int number = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(widget.paddingAmount),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
              onPressed: () {
                if (number > 1) {
                  setState(() {
                    number--;
                    widget.valueCallback!('$number');
                  });
                }
              },
              icon: const Icon(
                Icons.remove,
                color: accentColor,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('$number'),
          ),
          IconButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
              onPressed: () {
                if (number < widget.maxNum) {
                  setState(() {
                    number++;
                    widget.valueCallback!('$number');
                  });
                } else {
                  widget.callBack!();
                }
              },
              icon: const Icon(
                Icons.add,
                color: accentColor,
              )),
        ],
      ),
    );
  }
}
