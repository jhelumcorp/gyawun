import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/yt_music_base.dart';

part 'browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  final YTMusic ytmusic;
  final Map<String,dynamic> body;
  BrowseCubit(this.ytmusic,this.body) : super(BrowseInitial());

  Future<void> fetchData() async {
    try {
      emit(BrowseLoading());
      final data = await ytmusic.browseMore(body: body);
      emit(BrowseSuccess(data));
    } catch (e) {
      emit(BrowseError(e.toString()));
    }
  }
}

