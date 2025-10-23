import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/enums/section_type.dart';
import 'package:ytmusic/models/album.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  final YTMusic ytmusic;
  final Map<String,dynamic> body;
  AlbumCubit(this.ytmusic,this.body) : super(AlbumInitial());

   Future<void> fetchData() async {
    try {
      emit(AlbumLoading());
      final data = await ytmusic.getAlbum(body: body);
      emit(AlbumSuccess(data));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
    Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! AlbumSuccess) return;
    if(currentState.loadingMore)return;
    final currentData = currentState.data;
    
    final lastSection = currentData.sections.isNotEmpty
          ? currentData.sections.last
          : null;
    final continuation =lastSection?.continuation ?? currentData.continuation;
    if (continuation == null) return;

    emit(AlbumSuccess(currentData,loadingMore: true));

    try {

      if (lastSection?.continuation != null &&
          lastSection?.type == YTSectionType.singleColumn) {
        final nextPage = await ytmusic.getContinuationItems(
          body: body,
          continuation: lastSection!.continuation!,
        );

        final updatedSection = lastSection.copyWith(
          items: [...lastSection.items, ...nextPage.items],
          continuation: nextPage.continuation,
        );

        final updatedSections = [...currentData.sections];
        updatedSections[updatedSections.length - 1] = updatedSection;

        emit(AlbumSuccess(YTAlbumPage(header: currentData.header, sections: updatedSections, continuation: currentData.continuation)));
        return;
      }

      final nextPage = await ytmusic.getPlaylistSectionContinuation(
        body: body,
        continuation: currentData.continuation!,
      );

      final updatedSections = [...currentData.sections, ...nextPage.sections];

      emit(AlbumSuccess(YTAlbumPage(header: currentData.header,sections: updatedSections,continuation: nextPage.continuation)));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
