import 'package:flutter/material.dart';

class FilterByDialog extends StatefulWidget {
  @override
  _FilterByDialogState createState() => _FilterByDialogState();
}

class _FilterByDialogState extends State<FilterByDialog> {
  List<String> filters =  ["Categories","Brand","Stores","Products"];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
            filters.map((e) {
              return Column(
                children: [
                  SizedBox(height: 5,),
                  Text("$e",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              );
            }).toList(),
/*
          [
            SizedBox(height: 5,),
            Text("",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
          ],
*/
        ),
      ),
    );
  }
}
