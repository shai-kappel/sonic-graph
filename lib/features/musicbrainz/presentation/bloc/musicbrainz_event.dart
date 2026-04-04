import 'package:equatable/equatable.dart';

abstract class MusicBrainzEvent extends Equatable {
  const MusicBrainzEvent();

  @override
  List<Object?> get props => [];
}

class SearchArtistsEvent extends MusicBrainzEvent {
  final String query;

  const SearchArtistsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends MusicBrainzEvent {}
