import 'package:gyawun_music/providers/ytmusic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/ytmusic.dart';

part 'playlist_state_provider.g.dart';

@riverpod
class PlaylistStateNotifier extends _$PlaylistStateNotifier {
  late YTMusic _ytmusic;
  late Map<String, dynamic> _body;
  @override
  Future<PlaylistState> build(Map<String, dynamic> body) async {
    _body = body;
    _ytmusic = ref.watch(ytmusicProvider);
    final firstPage = await _ytmusic.getPlaylist(body);
    return PlaylistState(
      header: firstPage.header,
      sections: firstPage.sections,
      continuation: firstPage.continuation,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        current.isLoadingMore ||
        current.continuation == null) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = await _ytmusic.getPlaylistSectionContinuation(
        body: _body,
        continuation: current.continuation!,
      );
      final updatedSections = [...current.sections, ...nextPage.sections];
      state = AsyncValue.data(
        PlaylistState(
          header: current.header,
          sections: updatedSections,
          continuation: nextPage.continuation,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class PlaylistState {
  final YTPageHeader? header;
  final List<YTSection> sections;
  final String? continuation;
  final bool isLoadingMore;

  PlaylistState({
    required this.header,
    required this.sections,
    this.continuation,
    this.isLoadingMore = false,
  });

  PlaylistState copyWith({
    YTPageHeader? header,
    List<YTSection>? sections,
    String? continuation,
    bool? isLoadingMore,
  }) {
    return PlaylistState(
      header: header ?? this.header,
      sections: sections ?? this.sections,
      continuation: continuation ?? this.continuation,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
