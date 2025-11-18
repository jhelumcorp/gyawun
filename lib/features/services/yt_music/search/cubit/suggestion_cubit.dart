import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'suggestion_state.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  SuggestionCubit(this._yt) : super(SuggestionInitial());
  final YTMusic _yt;

  void fetchSuggestions(String? query) async {
    if (query == null) return;
    safeEmit(SuggestionLoading());
    try {
      final response = await _yt.getSearchSuggestions(query: query);
      safeEmit(SuggestionSuccess(response));
    } catch (e, s) {
      safeEmit(SuggestionError(e.toString(), s.toString()));
    }
  }

  void safeEmit(SuggestionState state) {
    if (!isClosed) emit(state);
  }
}
