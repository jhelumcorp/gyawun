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
    emit(SuggestionLoading());
    try {
      final response = await _yt.getSearchSuggestions(query: query);
      emit(SuggestionSuccess(response));
    } catch (e) {
      emit(SuggestionError(e.toString()));
    }
  }
}
