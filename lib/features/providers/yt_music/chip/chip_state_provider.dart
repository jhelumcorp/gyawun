import 'package:gyawun_music/providers/ytmusic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/ytmusic.dart';

part 'chip_state_provider.g.dart';

@riverpod
class ChipStateNotifier extends _$ChipStateNotifier {
  late YTMusic _ytmusic;
  @override
  Future<ChipState> build(Map<String, dynamic> body) async {
    _ytmusic = ref.watch(ytmusicProvider);
    final firstPage = await _ytmusic.getChipPage(body: body, limit: 5);
    return ChipState(
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
      final nextPage = await _ytmusic.getHomePageContinuation(
        current.continuation!,
      );
      final updatedSections = [...current.sections, ...nextPage.sections];
      state = AsyncValue.data(
        ChipState(
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

class ChipState {
  final List<YTSection> sections;
  final String? continuation;
  final bool isLoadingMore;

  ChipState({
    required this.sections,
    this.continuation,
    this.isLoadingMore = false,
  });

  ChipState copyWith({
    List<YTSection>? sections,
    String? continuation,
    bool? isLoadingMore,
  }) {
    return ChipState(
      sections: sections ?? this.sections,
      continuation: continuation ?? this.continuation,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
