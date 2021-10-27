part of 'tasting_list_bloc.dart';

@immutable
abstract class TastingListEvent {}

class InitTastings extends TastingListEvent {}

class FilterBySearchTermEvent extends TastingListEvent {
  @required
  final String keywordSearchTerm;
  FilterBySearchTermEvent({this.keywordSearchTerm});
}

class ToggleTastingListViewMode extends TastingListEvent {
  @required
  final TastingListViewMode viewMode;
  ToggleTastingListViewMode({this.viewMode});
}
