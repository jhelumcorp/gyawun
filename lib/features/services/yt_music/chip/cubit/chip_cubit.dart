import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'chip_state.dart';

class ChipCubit extends Cubit<ChipState> {
  ChipCubit(this.ytmusic, this.body, this.type) : super(ChipInitial());
  final YTMusic ytmusic;
  final Map<String, dynamic> body;
  final ChipType type;

  Future<void> fetchData() async {
    try {
      emit(ChipLoading());
      final data = await ytmusic.getChipPage(body: body, limit: 3, type: type);
      emit(ChipSuccess(data));
    } catch (e) {
      emit(ChipError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ChipSuccess) return;
    if (currentState.loadingMore) return;
    final currentData = currentState.data;
    final continuation = currentData.continuation;
    if (continuation == null) return;

    try {
      emit(ChipSuccess(currentData, loadingMore: true));
      final nextPage = await ytmusic.getChipPageContinuation(
        body: body,
        continuation: continuation,
        type: type,
      );
      final updatedSections = [...currentData.sections, ...nextPage.sections];
      final updatedData = Page(
        sections: updatedSections,
        continuation: nextPage.continuation,
        header: currentData.header,
        provider: currentData.provider,
      );
      emit(ChipSuccess(updatedData));
    } catch (e) {
      emit(ChipError(e.toString()));
    }
  }
}
