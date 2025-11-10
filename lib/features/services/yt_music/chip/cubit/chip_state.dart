part of 'chip_cubit.dart';

@immutable
sealed class ChipState {}

final class ChipInitial extends ChipState {}

final class ChipLoading extends ChipState {}

final class ChipSuccess extends ChipState {
  ChipSuccess(this.data, {this.loadingMore = false});
  final YTChipPage data;
  final bool loadingMore;
}

final class ChipError extends ChipState {
  ChipError([this.message]);
  final String? message;
}
