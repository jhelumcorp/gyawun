part of 'suggestion_cubit.dart';

@immutable
sealed class SuggestionState {}

final class SuggestionInitial extends SuggestionState {}

final class SuggestionLoading extends SuggestionState {}

final class SuggestionSuccess extends SuggestionState {
  SuggestionSuccess(this.data, {this.loadingMore = false});
  final YTSearchSuggestions data;
  final bool loadingMore;
}

final class SuggestionError extends SuggestionState {
  SuggestionError([this.message]);
  final String? message;
}
