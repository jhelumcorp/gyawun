import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/enums/section_type.dart';
import 'package:ytmusic/models/models.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'artist_state.dart';


class ArtistCubit extends Cubit<ArtistState> {
  final YTMusic ytmusic;
  final Map<String,dynamic> body;
  ArtistCubit(this.ytmusic,this.body) : super(ArtistInitial());

   Future<void> fetchData() async {
    try {
      emit(ArtistLoading());
      final data = await ytmusic.getArtist(body: body);
      emit(ArtistSuccess(data));
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }
    Future<void> loadMore() async {
      
    final currentState = state;
    if (currentState is! ArtistSuccess) return;
    
    if(currentState.loadingMore)return;

    
    final currentData = currentState.data;
    
    
    final lastSection = currentData.sections.isNotEmpty
          ? currentData.sections.last
          : null;
    
    final continuation =lastSection?.continuation ?? currentData.continuation;
    if (continuation == null) return;

    emit(ArtistSuccess(currentData,loadingMore: true));

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

        emit(ArtistSuccess(YTArtistPage(header: currentData.header, sections: updatedSections, continuation: currentData.continuation)));
        return;
      }

      final nextPage = await ytmusic.getPlaylistSectionContinuation(
        body: body,
        continuation: currentData.continuation!,
      );

      final updatedSections = [...currentData.sections, ...nextPage.sections];

      emit(ArtistSuccess(YTArtistPage(header: currentData.header,sections: updatedSections,continuation: nextPage.continuation)));
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }
}

