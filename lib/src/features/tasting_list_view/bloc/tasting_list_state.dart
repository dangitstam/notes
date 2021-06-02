part of 'tasting_list_bloc.dart';

@immutable
class TastingListState extends Equatable {
  final String keywordSearchTerm;
  final Set<Note> filterNotes;

  TastingListState({this.keywordSearchTerm, this.filterNotes = const <Note>{}});

  TastingListState copyWith({
    String keywordSearchTerm,
    Set<Note> filterNotes,
  }) {
    return TastingListState(
      keywordSearchTerm: keywordSearchTerm ?? this.keywordSearchTerm,
      filterNotes: filterNotes ?? this.filterNotes,
    );
  }

  @override
  List<Object> get props => [
        keywordSearchTerm,
        filterNotes,
      ];
}
