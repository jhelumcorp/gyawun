import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.ytmusic) : super(SearchInitial());
  final YTMusic ytmusic;
  Future<void> search(String query) async {
    try {
      safeEmit(SearchLoading());
      final data = await ytmusic.getSearch(query: query);
      safeEmit(SearchSuccess(data));
    } catch (e) {
      safeEmit(SearchError(e.toString()));
    }
  }

  Future<YTSearchSuggestions> searchSuggestions(String query) =>
      ytmusic.getSearchSuggestions(query: query);
  void safeEmit(SearchState state) {
    if (!isClosed) emit(state);
  }
}
