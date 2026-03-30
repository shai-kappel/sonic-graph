import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:flutter/material.dart';

void main() {
  group('CanvasBloc', () {
    test('initial state is default', () {
      expect(CanvasBloc().state, const CanvasState());
    });

    test(
      'emits isInitialized: true with nodes and edges when CanvasInitialized added',
      () {
        final bloc = CanvasBloc();
        bloc.add(const CanvasInitialized());
        expectLater(
          bloc.stream,
          emits(
            predicate<CanvasState>((state) {
              return state.isInitialized &&
                  state.nodes.length == 60 &&
                  state.edges.length == 59;
            }),
          ),
        );
      },
    );

    test('emits new matrix, zoom, and pan when CanvasTransformed added', () {
      final bloc = CanvasBloc();
      final matrix = Matrix4.diagonal3Values(2.0, 2.0, 1.0)
        ..setTranslationRaw(100.0, 50.0, 0.0);

      bloc.add(CanvasTransformed(matrix: matrix));

      expectLater(
        bloc.stream,
        emits(
          predicate<CanvasState>((state) {
            return state.zoomLevel == 2.0 && state.transformMatrix == matrix;
          }),
        ),
      );
    });
  });
}
