part of 'chip_cubit.dart';


@immutable
sealed class ChipState {}

final class ChipInitial extends ChipState {}
final class ChipLoading extends ChipState {}
final class ChipSuccess extends ChipState {
  final YTChipPage data;
  final bool loadingMore;
  ChipSuccess(this.data,{this.loadingMore=false});
}
final class ChipError extends ChipState {
  final String? message;
  ChipError([this.message]);
}

