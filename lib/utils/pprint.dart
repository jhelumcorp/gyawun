import 'dart:convert';
import 'dart:developer';

pprint(data) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(data);
  log(jsonString);
}
