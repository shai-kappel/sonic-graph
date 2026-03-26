import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  CanvasBloc() : super(const CanvasState()) {
    on<CanvasInitialized>(_onInitialized);
    on<CanvasTransformed>(_onTransformed);
    on<CanvasZoomChanged>(_onZoomChanged);
  }

  void _onInitialized(CanvasInitialized event, Emitter<CanvasState> emit) {
    emit(state.copyWith(isInitialized: true));
  }

  void _onTransformed(CanvasTransformed event, Emitter<CanvasState> emit) {
    final matrix = event.matrix;
    final zoom = matrix.getMaxScaleOnAxis();
    final translation = Offset(matrix.getTranslation().x, matrix.getTranslation().y);
    emit(state.copyWith(
      transformMatrix: matrix,
      zoomLevel: zoom,
      panOffset: translation,
    ));
  }

  void _onZoomChanged(CanvasZoomChanged event, Emitter<CanvasState> emit) {
    emit(state.copyWith(zoomLevel: event.zoomLevel));
  }
}
