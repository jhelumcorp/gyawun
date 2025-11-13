import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  ArtistCubit(this.ytmusic, this.body) : super(ArtistInitial());
  final YTMusic ytmusic;
  final Map<String, dynamic> body;

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

    if (currentState.loadingMore) return;

    final currentData = currentState.data;

    final lastSection = currentData.sections.isNotEmpty ? currentData.sections.last : null;

    final continuation = lastSection?.continuation ?? currentData.continuation;
    if (continuation == null) return;

    emit(ArtistSuccess(currentData, loadingMore: true));

    try {
      if (lastSection?.continuation != null && lastSection?.type == SectionType.singleColumn) {
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

        emit(
          ArtistSuccess(
            Page(
              header: currentData.header,
              sections: updatedSections,
              continuation: currentData.continuation,
              provider: currentData.provider,
            ),
          ),
        );
        return;
      }

      final nextPage = await ytmusic.getPlaylistSectionContinuation(
        body: body,
        continuation: currentData.continuation!,
      );

      final updatedSections = [...currentData.sections, ...nextPage.sections];

      emit(
        ArtistSuccess(
          Page(
            header: currentData.header,
            sections: updatedSections,
            continuation: nextPage.continuation,
            provider: currentData.provider,
          ),
        ),
      );
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }
}
