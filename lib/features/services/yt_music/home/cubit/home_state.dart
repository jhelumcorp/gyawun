part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  HomeSuccess(this.data, {this.loadingMore = false});
  final YTHomePage data;
  final bool loadingMore;
}

final class HomeError extends HomeState {
  HomeError([this.message, this.stackTrace]);
  final String? message;
  final String? stackTrace;
}
