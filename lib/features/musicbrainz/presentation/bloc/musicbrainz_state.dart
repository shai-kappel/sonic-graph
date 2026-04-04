import 'package:equatable/equatable.dart';
import '../../domain/entities/artist.dart';

abstract class MusicBrainzState extends Equatable {
  const MusicBrainzState();

  @override
  List<Object?> get props => [];
}

class MusicBrainzInitial extends MusicBrainzState {}

class MusicBrainzLoading extends MusicBrainzState {}

class MusicBrainzLoaded extends MusicBrainzState {
  final List<Artist> artists;

  const MusicBrainzLoaded(this.artists);

  @override
  List<Object?> get props => [artists];
}

class MusicBrainzError extends MusicBrainzState {
  final String message;

  const MusicBrainzError(this.message);

  @override
  List<Object?> get props => [message];
}
