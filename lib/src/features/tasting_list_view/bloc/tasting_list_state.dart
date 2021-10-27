part of 'tasting_list_bloc.dart';

@immutable
class TastingListState extends Equatable {
  final String keywordSearchTerm;
  final Set<Note> filterNotes;
  final TastingListViewMode viewMode;

  TastingListState({
    this.keywordSearchTerm,
    this.filterNotes = const <Note>{},
    this.viewMode = TastingListViewMode.card,
  });

  TastingListState copyWith({
    String keywordSearchTerm,
    Set<Note> filterNotes,
    TastingListViewMode viewMode,
  }) {
    return TastingListState(
      keywordSearchTerm: keywordSearchTerm ?? this.keywordSearchTerm,
      filterNotes: filterNotes ?? this.filterNotes,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object> get props => [
        keywordSearchTerm,
        filterNotes,
        viewMode,
      ];
}
