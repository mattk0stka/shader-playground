import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'shaders.dart';

import 'dart:typed_data';




class ScalTriangle extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

   final gpu.Texture? texture = gpu.gpuContext.createTexture(gpu.StorageMode.devicePrivate, 300, 300, enableRenderTargetUsage: true);
   if (texture == null) {
     return;
   }

   final vertex = shaderLibrary['SimpleVertex']!;
   final fragment = shaderLibrary['SimpleFragment']!;
   final pipeline = gpu.gpuContext.createRenderPipeline(vertex, fragment);

   final gpu.DeviceBuffer? vertexBuffer = gpu.gpuContext.createDeviceBuffer(gpu.StorageMode.hostVisible, 4 * 2 * 3);
   vertexBuffer!.overwrite(Float32List.fromList(<double>[
     -0.5, -0.5, //
     0.5, -0.5, //
     0.0,  0.5, //
   ]).buffer.asByteData());

   vertexBuffer.flush();

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