import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:jio_saavn/jio_saavn.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._js) : super(HomeInitial());
  final JioSaavn _js;

  Future<void> fetchData() async {
    try {
      emit(HomeLoading());
      final page = await _js.home.getLaunchData();
      emit(HomeSuccess(page));
    } catch (e, s) {
      emit(HomeError(e.toString(), s.toString()));
    }
  }

  Future<void> refreshdata() async {
    try {
      final data = await _js.home.getLaunchData();
      emit(HomeSuccess(data));
    } catch (e, s) {
      emit(HomeError(e.toString(), s.toString()));
    }
  }
}
