import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/ytmusic.dart';

part 'ytmusic_provider.g.dart';

@riverpod
YTMusic ytmusic(Ref ref) {
  return YTMusic();
}
