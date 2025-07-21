import 'package:gyawun_music/providers/ytmusic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/enums/section_type.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/ytmusic.dart';

part 'artist_state_provider.g.dart';

@riverpod
class ArtistStateNotifier extends _$ArtistStateNotifier {
  late YTMusic _ytmusic;
  late Map<String, dynamic> _body;
  @override
  Future<ArtistState> build(Map<String, dynamic> body) async {
    _body = body;
    _ytmusic = ref.watch(ytmusicProvider);
    final firstPage = await _ytmusic.getArtist(body: body);
    return ArtistState(
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
      final lastSection = current.sections.isNotEmpty
          ? current.sections.last
          : null;
      if (lastSection?.continuation != null &&
          lastSection?.type == YTSectionType.singleColumn) {
        final nextPage = await _ytmusic.getContinuationItems(
          body: _body,
          continuation: lastSection!.continuation!,
        );

        final updatedSection = YTSection(
          title: lastSection.title,
          strapline: lastSection.strapline,
          trailing: lastSection.trailing,
          type: lastSection.type,
          items: [...lastSection.items, ...nextPage.items],
          continuation: nextPage.continuation,
        );

        final updatedSections = [...current.sections];
        updatedSections[updatedSections.length - 1] = updatedSection;

        state = AsyncValue.data(
          current.copyWith(sections: updatedSections, isLoadingMore: false),
        );
        return;
      }

      final nextPage = await _ytmusic.getPlaylistSectionContinuation(
        body: _body,
        continuation: current.continuation!,
      );
      final updatedSections = [...current.sections, ...nextPage.sections];
      state = AsyncValue.data(
        ArtistState(
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

class ArtistState {
  final YTPageHeader? header;
  final List<YTSection> sections;
  final String? continuation;
  final bool isLoadingMore;

  ArtistState({
    required this.header,
    required this.sections,
    this.continuation,
    this.isLoadingMore = false,
  });

  ArtistState copyWith({
    YTPageHeader? header,
    List<YTSection>? sections,
    String? continuation,
    bool? isLoadingMore,
  }) {
    return ArtistState(
      header: header ?? this.header,
      sections: sections ?? this.sections,
      continuation: continuation ?? this.continuation,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
