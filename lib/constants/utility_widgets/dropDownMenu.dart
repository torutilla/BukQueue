import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class UtilityDropDownMenu extends StatelessWidget {
  final List<String> dropDownEntries;
  final double borderRadius;
  final TextEditingController textEditingController;
  final double width;
  final String hintText;
  final Color borderColor;
  const UtilityDropDownMenu({
    super.key,
    this.hintText = '',
    required this.dropDownEntries,
    this.borderRadius = 8,
    required this.textEditingController,
    this.width = double.infinity,
    this.borderColor = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        label: Text(hintText),
        width: width,
        controller: textEditingController,
        menuStyle: const MenuStyle(
            fixedSize: WidgetStatePropertyAll(Size.fromHeight(120))),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(borderRadius)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
        initialSelection: dropDownEntries[0],
        dropdownMenuEntries: List.generate(dropDownEntries.length, (index) {
          return DropdownMenuEntry(
            value: dropDownEntries[index],
            label: dropDownEntries[index],
          );
        }));
  }
}
