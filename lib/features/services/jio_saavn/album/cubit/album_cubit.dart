import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:jio_saavn/jio_saavn.dart';
import 'package:meta/meta.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit(this._js, this.id) : super(AlbumInitial());
  final JioSaavn _js;
  final String id;
  final _modules = [];

  Future<void> fetchData() async {
    try {
      emit(AlbumLoading());
      final data = await _js.albums.detailsById(id);
      if (data.header?.modules != null) {
        _modules.addAll(data.header!.modules);
      }
      emit(AlbumSuccess(data));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
