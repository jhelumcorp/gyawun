import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:meta/meta.dart';
import 'package:ytmusic/ytmusic.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(this.ytmusic) : super(ExploreInitial());
  final YTMusic ytmusic;

  Future<void> fetch() async {
    try {
      emit(ExploreLoading());
      final data = await ytmusic.getExplore();
      emit(ExploreSuccess(data));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }
}
