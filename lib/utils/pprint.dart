import 'dart:convert';
import 'dart:developer';

pprint(json) {
  var encoder = const JsonEncoder.withIndent("     ");
  String str = encoder.convert(json);
  log(str);
}
