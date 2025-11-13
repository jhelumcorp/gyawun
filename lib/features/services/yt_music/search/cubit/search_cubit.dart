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
      emit(SearchLoading());
      final data = await ytmusic.getSearch(query: query);
      emit(SearchSuccess(data));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<YTSearchSuggestions> searchSuggestions(String query) =>
      ytmusic.getSearchSuggestions(query: query);
}
