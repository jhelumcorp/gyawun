import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';

SimpleDialog optionSelectionDialog<T>(BuildContext context,{String? title,List<AppDialogTileData<T>> children=const[]}){
  return SimpleDialog(
    title: Text(title??'Selection Dialog',style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
    contentPadding: EdgeInsetsGeometry.only(bottom: 24,top: 8,left: 8,right: 8),
    children: 
      children.map((child)=>ListTile(
        dense: true,
        title: Text(child.title,style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
        onTap: () => Navigator.pop(context,child.value),
      )).toList()
    ,
  );
}