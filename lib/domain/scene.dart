

import 'dart:ui' as ui;

import '../src_engine/camera.dart';

class Scene {

  // todo: method that ensures all necessary resources are loaded and ready



  void render(Camera camera, ui.Canvas canvas) {
    final drawArea = canvas.getLocalClipBounds();

    if (drawArea.isEmpty) {
      return;
    }
  }
}