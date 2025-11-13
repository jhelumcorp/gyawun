import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'podcast_state.dart';

class PodcastCubit extends Cubit<PodcastState> {
  PodcastCubit(this.ytmusic, this.body) : super(PodcastInitial());
  final YTMusic ytmusic;
  final Map<String, dynamic> body;

  Future<void> fetchData() async {
    try {
      emit(PodcastLoading());
      final data = await ytmusic.getPodcast(body: body);
      emit(PodcastSuccess(data));
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! PodcastSuccess) return;
    if (currentState.loadingMore) return;
    final currentData = currentState.data;

    final lastSection = currentData.sections.isNotEmpty ? currentData.sections.last : null;
    final continuation = lastSection?.continuation ?? currentData.continuation;
    if (continuation == null) return;

    emit(PodcastSuccess(currentData, loadingMore: true));

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
          PodcastSuccess(
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

      final nextPage = await ytmusic.getPodcastContinuation(
        body: body,
        continuation: currentData.continuation!,
      );

      final List<Section> updatedSections = [...currentData.sections, ...nextPage.sections];

      emit(
        PodcastSuccess(
          Page(
            header: currentData.header,
            sections: updatedSections,
            continuation: nextPage.continuation,
            provider: currentData.provider,
          ),
        ),
      );
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }
}
