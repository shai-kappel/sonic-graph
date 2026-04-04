import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final String id;
  final String label;
  final String? parentGenreId;
  final String? parentGenreLabel;

  const Genre({
    required this.id,
    required this.label,
    this.parentGenreId,
    this.parentGenreLabel,
  });

  @override
  List<Object?> get props => [id, label, parentGenreId, parentGenreLabel];
}
