import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/usecases/search_artists.dart';
import 'musicbrainz_event.dart';
import 'musicbrainz_state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class MusicBrainzBloc extends Bloc<MusicBrainzEvent, MusicBrainzState> {
  final SearchArtists searchArtists;

  MusicBrainzBloc({required this.searchArtists}) : super(MusicBrainzInitial()) {
    on<SearchArtistsEvent>(
      _onSearchArtists,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchArtists(
    SearchArtistsEvent event,
    Emitter<MusicBrainzState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(MusicBrainzInitial());
      return;
    }

    emit(MusicBrainzLoading());

    try {
      final results = await searchArtists.execute(event.query);
      emit(MusicBrainzLoaded(results));
    } catch (e) {
      emit(MusicBrainzError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<MusicBrainzState> emit) {
    emit(MusicBrainzInitial());
  }
}
