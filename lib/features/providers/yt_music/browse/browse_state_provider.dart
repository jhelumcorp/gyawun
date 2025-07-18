import 'package:gyawun_music/providers/ytmusic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'browse_state_provider.g.dart';

@riverpod
class BrowseStateNotifier extends _$BrowseStateNotifier {
  late YTMusic _ytmusic;
  @override
  Future<YTBrowsePage> build(Map<String, dynamic> body) async {
    _ytmusic = ref.watch(ytmusicProvider);
    return await _ytmusic.browseMore(body);
  }
}
