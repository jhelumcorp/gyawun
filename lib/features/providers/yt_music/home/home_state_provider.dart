import 'package:gyawun_music/providers/ytmusic_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ytmusic/ytmusic.dart';

part 'home_state_provider.g.dart';

@riverpod
class HomeStateNotifier extends _$HomeStateNotifier {
  late YTMusic _ytmusic;
  @override
  Future<HomeState> build() async {
    _ytmusic = ref.watch(ytmusicProvider);
    final firstPage = await _ytmusic.getHomePage(limit: 5);
    return HomeState(
      chips: firstPage.chips,
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
        continuation: current.continuation!,
      );
      final updatedSections = [...current.sections, ...nextPage.sections];
      state = AsyncValue.data(
        HomeState(
          chips: current.chips,
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

class HomeState {
  final List<YTChip> chips;
  final List<YTSection> sections;
  final String? continuation;
  final bool isLoadingMore;

  HomeState({
    required this.chips,
    required this.sections,
    this.continuation,
    this.isLoadingMore = false,
  });

  HomeState copyWith({
    List<YTChip>? chips,
    List<YTSection>? sections,
    String? continuation,
    bool? isLoadingMore,
  }) {
    return HomeState(
      chips: chips ?? this.chips,
      sections: sections ?? this.sections,
      continuation: continuation ?? this.continuation,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
