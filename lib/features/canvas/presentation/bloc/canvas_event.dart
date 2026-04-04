import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CanvasEvent extends Equatable {
  const CanvasEvent();
  @override
  List<Object?> get props => [];
}

class CanvasInitialized extends CanvasEvent {
  const CanvasInitialized();
}

class CanvasTransformed extends CanvasEvent {
  const CanvasTransformed({required this.matrix});
  final Matrix4 matrix;
  @override
  List<Object?> get props => [matrix];
}

class CanvasZoomChanged extends CanvasEvent {
  const CanvasZoomChanged({required this.zoomLevel});
  final double zoomLevel;
  @override
  List<Object?> get props => [zoomLevel];
}

class AddNodeEvent extends CanvasEvent {
  const AddNodeEvent({
    required this.label,
    required this.position,
    this.metadata = const {},
  });
  final String label;
  final Offset position;
  final Map<String, dynamic> metadata;
  @override
  List<Object?> get props => [label, position, metadata];
}

class ExpandNodeRequest extends CanvasEvent {
  const ExpandNodeRequest({required this.nodeId});
  final String nodeId;
  @override
  List<Object?> get props => [nodeId];
}

class LoadMacroEvolution extends CanvasEvent {
  const LoadMacroEvolution({required this.nodeId});
  final String nodeId;
  @override
  List<Object?> get props => [nodeId];
}
