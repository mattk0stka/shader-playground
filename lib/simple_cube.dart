
import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'shaders.dart';

class SimpleCube extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
   final gpu.Texture? texture =  gpu.gpuContext.createTexture(gpu.StorageMode.devicePrivate, 300, 300, enableRenderTargetUsage: true);
   if (texture == null){
     return;
   }

   final vertex = shaderLibrary['ColorsVertex']!;
   final fragment = shaderLibrary['ColorsFragment']!;
   final pipeline = gpu.gpuContext.createRenderPipeline(vertex, fragment);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}