import 'package:flutter/material.dart';
import 'package:speak_app/Screens/home_screen.dart';

class ConfirmationDialog extends StatelessWidget {
  final BuildContext parentContext;

  const ConfirmationDialog({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Text("¿Seguro?", style: Theme.of(context).textTheme.headlineSmall,),
      content: Text("Al volver al menú perderas el progreso en la actividad", 
                style: Theme.of(context).textTheme.bodyMedium,),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (parentContext) => HomeScreen()),
            );
          },
          icon: Icon(Icons.done, color: Theme.of(context).primaryColor),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.do_not_disturb, color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
