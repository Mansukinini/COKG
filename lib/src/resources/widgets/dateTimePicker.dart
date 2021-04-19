import 'package:cokg/src/styles/textfields.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateTimePicker extends StatefulWidget {
  final void Function(DateTime) onChanged;
  final DateTime initialValue;
  final String dateLabelText; 
  final String timeLabelText;
  final bool readyOnly;

  AppDateTimePicker({
    @required this.dateLabelText,
    this.timeLabelText, 
    this.onChanged,
    this.initialValue,
    this.readyOnly = false
  });

  @override
  _AppDateTimePickerState createState() => _AppDateTimePickerState();
}

class _AppDateTimePickerState extends State<AppDateTimePicker> {
  TextEditingController _controller;

  @override
  void initState() {
    // _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.initialValue);
    }

    // _node.addListener(_handleFocusChange);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(top:12.0, left: 10.0, right: 10.0, bottom: 12.0),
      child: DateTimeField(
        readOnly: widget.readyOnly,
        onChanged: widget.onChanged,
        style: TextFieldStyles.text,
        controller: _controller,
        decoration: TextFieldStyles.materialDecoration(widget.dateLabelText, null, null, null),
        format: DateFormat("yyyy-MM-dd HH:mm"),
        onShowPicker: (context, currentValue) async {

          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: widget.initialValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(widget.initialValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }


}