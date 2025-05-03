import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'shaders.dart';

import 'dart:typed_data';

/*
  powerful and flexible way to draw custom graphics directly onto a Canvas.
  It allows you to create complex visual elements such as charts, game graphics.
 */
class ColorsPainter extends CustomPainter {

  ColorsPainter(this.red, this.green, this.blue);

  double red;
  double green;
  double blue;


  @override
  void paint(Canvas canvas, Size size) {

    /*
       devicePrivate
     */
    final gpu.Texture? texture = gpu.gpuContext.createTexture(gpu.StorageMode.devicePrivate, 300, 300,
    enableRenderTargetUsage: true);
    if (texture == null) {
      return;
    }

    final vertex = shaderLibrary['ColorsVertex']!;
    final fragment = shaderLibrary['ColorsFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vertex, fragment);

    // if overwriting the texture's data by uploading it from the host (CPU), then use StorageMode.hostVisible
    final gpu.DeviceBuffer? vertexBuffer = gpu.gpuContext.createDeviceBuffer(gpu.StorageMode.hostVisible, 4 * 6 * 3);

    vertexBuffer!.overwrite(Float32List.fromList(<double>[
      -0.5, -0.5,  1.0*red, 0.0, 0.0, 1.0, //
      0.5, -0.5,  0.0, 1.0*green, 0.0, 1.0, //
      0.0,  0.5,  0.0, 0.0, 1.0*blue, 1.0, //
    ]).buffer.asByteData());

    final commandBuffer = gpu.gpuContext.createCommandBuffer();

    final renderTarget = gpu.RenderTarget.singleColor(gpu.ColorAttachment(texture: texture!));

    final pass = commandBuffer.createRenderPass(renderTarget);
    
    pass.bindPipeline(pipeline);
    pass.bindVertexBuffer(
        gpu.BufferView(vertexBuffer,
            offsetInBytes: 0, lengthInBytes: vertexBuffer.sizeInBytes), 3);
    pass.draw();

    commandBuffer.submit();

    final image = texture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}