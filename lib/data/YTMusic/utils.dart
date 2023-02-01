getItemText(item, index, {run_index: 0, none_if_absent: false}) {
  dynamic column = getFlexColumnItem(item, index);
  if (column == null) {
    return null;
  }
  if (none_if_absent && column['text']['runs'].length < run_index + 1) {
    return null;
  }
  return column['text']['runs'][run_index]['text'];
}

getFlexColumnItem(item, index) {
  if (item['flexColumns'].length <= index ||
      !item['flexColumns'][index]['musicResponsiveListItemFlexColumnRenderer']
          .containsKey('text') ||
      !item['flexColumns'][index]['musicResponsiveListItemFlexColumnRenderer']
              ['text']
          .containsKey('runs')) {
    return null;
  }
  return item['flexColumns'][index]
      ['musicResponsiveListItemFlexColumnRenderer'];
}
