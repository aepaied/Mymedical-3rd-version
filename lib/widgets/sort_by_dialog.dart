import 'package:flutter/material.dart';

class SortByDialog extends StatefulWidget {
  @override
  _SortByDialogState createState() => _SortByDialogState();
}

class _SortByDialogState extends State<SortByDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Text("Price low to high",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("Price high to low",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("Latest products",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("Best seller",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("Top Rated",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
