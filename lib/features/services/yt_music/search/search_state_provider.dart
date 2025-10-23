// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gyawun_music/providers/ytmusic_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:ytmusic/models/search.dart';
// import 'package:ytmusic/ytmusic.dart';

// part 'search_state_provider.g.dart';

// @riverpod
// class SearchStateNotifier extends _$SearchStateNotifier {
//   late YTMusic _ytmusic;
//   @override
//   Future<SearchState> build(String query) async {
//     _ytmusic = ref.watch(ytmusicProvider);
//     final firstPage = await _ytmusic.getSearch(query: query);
//     return SearchState(sections: firstPage.sections, isLoadingMore: false);
//   }
// }

// // final getSuggestionsProvider = Provider<YTSearchSuggestions>(
// //   (ref, query) async {},
// // );

// @riverpod
// Future<YTSearchSuggestions> getSuggestions(Ref ref, String query) async {
//   return ref.read(ytmusicProvider).getSearchSuggestions(query: query);
// }

// class SearchState {
//   final List<YTSection> sections;
//   final bool? isLoadingMore;

//   SearchState({required this.sections, this.isLoadingMore = false});

//   SearchState copyWith({List<YTSection>? sections, bool? isLoadingMore}) {
//     return SearchState(
//       sections: sections ?? this.sections,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//     );
//   }
// }
