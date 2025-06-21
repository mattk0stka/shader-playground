import 'dart:typed_data';

import 'package:flutter_gpu/gpu.dart' as gpu;

abstract class Material {

  static gpu.Texture? _whitePlaceholderTexture;

  static gpu.Texture getWhitePlaceholderTexture() {
    if (_whitePlaceholderTexture != null) {
      return _whitePlaceholderTexture!;
    }

    // alloc mem for texture, overwrite and return
    _whitePlaceholderTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.hostVisible, 1, 1
    );

    if (_whitePlaceholderTexture == null) {
      throw Exception('failed to create white placeholder texture');
    }

    _whitePlaceholderTexture!.overwrite(
      Uint32List.fromList(<int>[0xFFF7F7F]).buffer.asByteData(),
    );

    return _whitePlaceholderTexture!;
  }

  static gpu.Texture whitePlaceholder(gpu.Texture? texture) {
    return texture ?? getWhitePlaceholderTexture();
  }


  gpu.Shader? _fragmentShader;
  gpu.Shader get fragmentShader {
     if (_fragmentShader == null) {
       throw Exception('fragment shader has not been set');
     }
     return _fragmentShader!;
  }

  void setFragmentShader(gpu.Shader shader) {
    _fragmentShader = shader;
  }


  void bind(
      gpu.RenderPass pass,
      gpu.HostBuffer transientsBuffer,
      ) {
    pass.setCullMode(gpu.CullMode.backFace);
    pass.setWindingOrder(gpu.WindingOrder.counterClockwise);
  }
}