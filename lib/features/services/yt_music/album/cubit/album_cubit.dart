import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gyawun_shared/gyawun_shared.dart' as dp;
import 'package:meta/meta.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit(this.ytmusic, this.body) : super(AlbumInitial());
  final YTMusic ytmusic;
  final Map<String, dynamic> body;

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
    if (currentState.loadingMore) return;
    final currentData = currentState.data;

    final lastSection = currentData.sections.isNotEmpty ? currentData.sections.last : null;
    final continuation = lastSection?.continuation ?? currentData.continuation;
    if (continuation == null) return;

    emit(AlbumSuccess(currentData, loadingMore: true));

    try {
      if (lastSection?.continuation != null && lastSection?.type == dp.SectionType.singleColumn) {
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
          AlbumSuccess(
            dp.Page(
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
        AlbumSuccess(
          dp.Page(
            header: currentData.header,
            sections: updatedSections,
            continuation: nextPage.continuation,
            provider: currentData.provider,
          ),
        ),
      );
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
