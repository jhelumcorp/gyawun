import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/models/chip_page.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'chip_state.dart';

class ChipCubit extends Cubit<ChipState> {
  final YTMusic ytmusic;
  final Map<String,dynamic> body;
  ChipCubit(this.ytmusic,this.body) : super(ChipInitial());

  Future<void> fetchData() async {
    try {
      emit(ChipLoading());
      final data = await ytmusic.getChipPage(body: body,limit: 3);
      emit(ChipSuccess(data));
    } catch (e) {
      emit(ChipError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ChipSuccess) return;
    if(currentState.loadingMore)return;
    final currentData = currentState.data;
    final continuation = currentData.continuation;
    if (continuation == null) return;

    try {
      emit(ChipSuccess(currentData, loadingMore: true));
      final nextPage =
          await ytmusic.getChipPageContinuation(body: body,continuation: continuation);
      final updatedSections = [
        ...currentData.sections,
        ...nextPage.sections,
      ];
      final updatedData = YTChipPage(
        sections: updatedSections,
        continuation: nextPage.continuation,
      );
      emit(ChipSuccess(updatedData));
    } catch (e) {
      emit(ChipError(e.toString()));
    }
  }
}
