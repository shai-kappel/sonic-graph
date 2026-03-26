import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CanvasState extends Equatable {
  const CanvasState({
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
    this.transformMatrix,
    this.isInitialized = false,
  });

  final double zoomLevel;
  final Offset panOffset;
  final Matrix4? transformMatrix;
  final bool isInitialized;

  CanvasState copyWith({
    double? zoomLevel,
    Offset? panOffset,
    Matrix4? transformMatrix,
    bool? isInitialized,
  }) {
    return CanvasState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
      transformMatrix: transformMatrix ?? this.transformMatrix,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [zoomLevel, panOffset, isInitialized];
}
