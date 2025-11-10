import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ytmusic/ytmusic.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.ytmusic) : super(HomeInitial());
  final YTMusic ytmusic;

  void loadConfig() {}

  Future<void> fetchData() async {
    try {
      emit(HomeLoading());
      final data = await ytmusic.getHomePage(limit: 3);
      emit(HomeSuccess(data));
    } catch (e, s) {
      emit(HomeError(e.toString(), s.toString()));
    }
  }

  Future<void> refreshdata() async {
    try {
      final data = await ytmusic.getHomePage(limit: 3);
      emit(HomeSuccess(data));
    } catch (e, s) {
      emit(HomeError(e.toString(), s.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;
    if (currentState.loadingMore) return;
    final currentData = currentState.data;
    final continuation = currentData.continuation;
    if (continuation == null) return;

    try {
      emit(HomeSuccess(currentData, loadingMore: true));
      final nextPage = await ytmusic.getHomePageContinuation(
        continuation: continuation,
      );
      final updatedSections = [...currentData.sections, ...nextPage.sections];
      final updatedData = YTHomePage(
        chips: currentData.chips,
        sections: updatedSections,
        continuation: nextPage.continuation,
      );
      emit(HomeSuccess(updatedData));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
