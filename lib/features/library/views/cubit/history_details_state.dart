part of 'history_details_cubit.dart';

@immutable
sealed class HistoryDetailsState {}

final class HistoryDetailsInitial extends HistoryDetailsState {}

final class HistoryDetailsLoading extends HistoryDetailsState {}

final class HistoryDetailsSuccess extends HistoryDetailsState {
  HistoryDetailsSuccess(this.songs);
  final List<PlayableItem> songs;
}

final class HistoryDetailsError extends HistoryDetailsState {
  HistoryDetailsError([this.message]);
  final String? message;
}
