import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.ytmusic) : super(SearchInitial());
  final YTMusic ytmusic;
  Future<void> search(String query) async {
    try {
      emit(SearchLoading());
      final data = await ytmusic.getSearch(query: query);
      emit(SearchSuccess(data));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<YTSearchSuggestions> searchSuggestions(String query) =>
      ytmusic.getSearchSuggestions(query: query);
}
// class PlaylistCubit extends Cubit<PlaylistState> {
//   final YTMusic ytmusic;
//   final Map<String,dynamic> body;
//   PlaylistCubit(this.ytmusic,this.body) : super(PlaylistInitial());

//    Future<void> fetchData() async {
//     try {
//       emit(PlaylistLoading());
//       final data = await ytmusic.getPlaylist(body: body);
//       emit(PlaylistSuccess(data));
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }
//     Future<void> loadMore() async {
//     final currentState = state;
//     if (currentState is! PlaylistSuccess) return;
//     if(currentState.loadingMore)return;
//     final currentData = currentState.data;

//     final lastSection = currentData.sections.isNotEmpty
//           ? currentData.sections.last
//           : null;
//     final continuation =lastSection?.continuation ?? currentData.continuation;
//     if (continuation == null) return;

//     emit(PlaylistSuccess(currentData,loadingMore: true));

//     try {

//       if (lastSection?.continuation != null &&
//           lastSection?.type == YTSectionType.singleColumn) {
//         final nextPage = await ytmusic.getContinuationItems(
//           body: body,
//           continuation: lastSection!.continuation!,
//         );

//         final updatedSection = lastSection.copyWith(
//           items: [...lastSection.items, ...nextPage.items],
//           continuation: nextPage.continuation,
//         );

//         final updatedSections = [...currentData.sections];
//         updatedSections[updatedSections.length - 1] = updatedSection;

//         emit(PlaylistSuccess(YTPlaylistPage(header: currentData.header, sections: updatedSections, continuation: currentData.continuation)));
//         return;
//       }

//       final nextPage = await ytmusic.getPlaylistSectionContinuation(
//         body: body,
//         continuation: currentData.continuation!,
//       );

//       final updatedSections = [...currentData.sections, ...nextPage.sections];

//       emit(PlaylistSuccess(YTPlaylistPage(header: currentData.header,sections: updatedSections,continuation: nextPage.continuation)));
//     } catch (e) {
//       emit(PlaylistError(e.toString()));
//     }
//   }
// }
