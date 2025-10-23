// import 'package:gyawun_music/providers/ytmusic_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:ytmusic/enums/section_type.dart';
// import 'package:ytmusic/models/browse_page.dart';
// import 'package:ytmusic/ytmusic.dart';

// part 'podcast_state_provider.g.dart';

// @riverpod
// class PodcastStateNotifier extends _$PodcastStateNotifier {
//   late YTMusic _ytmusic;
//   late Map<String, dynamic> _body;
//   @override
//   Future<PodcastState> build(Map<String, dynamic> body) async {
//     _body = body;
//     _ytmusic = ref.watch(ytmusicProvider);
//     final firstPage = await _ytmusic.getPodcast(body: body);

//     return PodcastState(
//       header: firstPage.header,
//       sections: firstPage.sections,
//       continuation: firstPage.continuation,
//       isLoadingMore: false,
//     );
//   }

//   Future<void> loadMore() async {
//     final current = state.asData?.value;
//     if (current == null || current.isLoadingMore) return;
//     if (current.continuation == null &&
//         current.sections.last.continuation == null) {
//       return;
//     }

//     state = AsyncValue.data(current.copyWith(isLoadingMore: true));

//     try {
//       final lastSection = current.sections.isNotEmpty
//           ? current.sections.last
//           : null;

//       if (lastSection?.continuation != null &&
//           lastSection?.type == YTSectionType.singleColumn) {
//         final nextPage = await _ytmusic.getContinuationItems(
//           body: _body,
//           continuation: lastSection!.continuation!,
//         );

//         final updatedSection = YTSection(
//           title: lastSection.title,
//           strapline: lastSection.strapline,
//           trailing: lastSection.trailing,
//           type: lastSection.type,
//           items: [...lastSection.items, ...nextPage.items],
//           continuation: nextPage.continuation,
//         );

//         final updatedSections = [...current.sections];
//         updatedSections[updatedSections.length - 1] = updatedSection;

//         state = AsyncValue.data(
//           current.copyWith(sections: updatedSections, isLoadingMore: false),
//         );
//         return;
//       }

//       if (current.continuation != null) {
//         // final nextPage = await _ytmusic.getPodcastContinuation(
//         //   body: _body,
//         //   continuation: current.continuation!,
//         // );

//         // final updatedSections = [...current.sections, ...nextPage.sections];

//         // state = AsyncValue.data(
//         //   current.copyWith(
//         //     sections: updatedSections,
//         //     continuation: nextPage.continuation,
//         //     isLoadingMore: false,
//         //   ),
//         // );
//         // return;
//       }

//       // 3️⃣ Nothing more to load
//       state = AsyncValue.data(current.copyWith(isLoadingMore: false));
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
// }

// class PodcastState {
//   final YTPageHeader? header;
//   final List<YTSection> sections;
//   final String? continuation;
//   final bool isLoadingMore;

//   PodcastState({
//     required this.header,
//     required this.sections,
//     this.continuation,
//     this.isLoadingMore = false,
//   });

//   PodcastState copyWith({
//     YTPageHeader? header,
//     List<YTSection>? sections,
//     String? continuation,
//     bool? isLoadingMore,
//   }) {
//     return PodcastState(
//       header: header ?? this.header,
//       sections: sections ?? this.sections,
//       continuation: continuation ?? this.continuation,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//     );
//   }
// }
