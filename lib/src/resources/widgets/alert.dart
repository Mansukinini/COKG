import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

abstract class AppAlerts {

  static Future<void> showErrorDialog(BuildContext context, String errorMessage) {

    return showDialog(  
      context: context,
      barrierDismissible: false,
      builder: (context){
        
        return AlertDialog(  
          title: Text('Error',style: TextStyles.subtitle,),
          content: SingleChildScrollView(  
            child: ListBody(  
              children: <Widget>[
                Text(errorMessage, style: TextStyles.body)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(  
              child: Text('Okay',style: TextStyles.body),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

}