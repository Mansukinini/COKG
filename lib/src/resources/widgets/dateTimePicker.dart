import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class AppDateTimePicker extends StatelessWidget {
  final void Function(String) onChanged;
  final String initialValue;
  final String dateFormat;
  final String dateLabelText;
  final String timeLabelText;

  AppDateTimePicker({
    @required this.dateLabelText,
    this.timeLabelText,
    this.dateFormat = 'yyyy-MM-dd', 
    this.onChanged,
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {

   
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0),
      child: DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        dateMask: dateFormat,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialValue: initialValue,
        // icon: Icon(Icons.event),
        dateLabelText: dateLabelText,
        timeLabelText: timeLabelText,
        onChanged: onChanged,
        
        // validator: (val) {    
        //   print(val);
        //   return null;
        // },
          // onSaved: (val) => eventProvider.setDate(DateTime.parse(val)),
       
      ),
    );
  }
}