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
