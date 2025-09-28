import 'package:flutter/material.dart';

Dialog colorSelectionDialog(BuildContext context){
  return Dialog(
    child:Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        
        children: Colors.primaries.map((color)=>GestureDetector(
          onTap: () {
            Navigator.pop<Color>(context,color);
          },
          child: CircleAvatar(
            radius:20,
            backgroundColor: color,
          ),
        )).toList(),
      ),
    ) ,
  );
}