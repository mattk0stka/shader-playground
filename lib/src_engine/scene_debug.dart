
import 'package:flutter/cupertino.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

enum AntiAliasingMode {none, msaa}

class SceneDebug {

  // default none
  AntiAliasingMode _antiAliasingMode = AntiAliasingMode.none;
  SceneDebug() {
    antiAliasingMode = AntiAliasingMode.msaa;
  }

  set antiAliasingMode(AntiAliasingMode value) {
    switch (value) {
      case AntiAliasingMode.none:
        break; // do nothing
      case AntiAliasingMode.msaa:
        if (gpu.gpuContext.doesSupportOffscreenMSAA) {
          debugPrint('msaa is not currently on this backend');
          // leave function without changes
          return;
        }
    }
     _antiAliasingMode = value;
  }

}