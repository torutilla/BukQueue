import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';

class CustomDatePicker extends StatefulWidget {
  final String fieldText;
  final double customWidth;
  final void Function(String date) onDateSelected;
  const CustomDatePicker(
      {super.key,
      required this.fieldText,
      required this.onDateSelected,
      this.customWidth = 0});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFieldFormat(
      validator: (input) {
        if (input == null || input.isEmpty) {
          return 'Date cannot be empty';
        }

        if (!isValidDateYYYYMMDD(input)) {
          return 'Invalid date. Try using the date picker instead';
        }
        return null;
      },
      textInputType: TextInputType.datetime,
      borderRadius: 8,
      formText: widget.fieldText,
      fieldHeight: 70,
      fieldWidth: widget.customWidth,
      controller: dateController,
      suffixIcon: IconButton(
        color: primaryColor,
        onPressed: () {
          _pickDate(context);
        },
        icon: const Icon(Icons.date_range_rounded),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.transparent))),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
            datePickerTheme: Theme.of(context).datePickerTheme,
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      fieldLabelText: 'Date in MM/DD/YY',
      fieldHintText: 'Select Date',
      errorFormatText: 'Select Date',
      context: context,
      firstDate: DateTime.utc(2023, 01, 01),
      lastDate: DateTime.utc(2040, 12, 31),
    );

    if (picker != null) {
      dateController.text = picker.toString().split(" ")[0];
      widget.onDateSelected(dateController.text);
    }
  }

  bool isValidDateYYYYMMDD(String input) {
    RegExp dateRegex =
        RegExp(r'^(?:\d{4})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');

    if (!dateRegex.hasMatch(input)) return false;

    // Split input and check valid days per month
    List<String> parts = input.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    List<int> daysInMonth = [
      31,
      _isLeapYear(year) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return day <= daysInMonth[month - 1];
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
