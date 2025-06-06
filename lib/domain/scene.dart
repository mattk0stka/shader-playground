import 'package:flutter_gpu/gpu.dart' as gpu;

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

  gpu.RenderTarget getRenderTarget(ui.Size size, bool enableMsaa) {
    gpu.Texture colorTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      // target that the GPU writes to during rendering.
      // colorAttachment
      enableRenderTargetUsage: true,
      enableShaderReadUsage: true,
      coordinateSystem: gpu.TextureCoordinateSystem.renderToTexture
    );

    // structure that describes where and  how to store color output
    // attachment is a memory location that can act as a buffer for the framebuffer.
    // fragmentShader outputs a color, which is written into this attachment.
    final colorAttachment = gpu.ColorAttachment(texture: colorTexture);

    if (enableMsaa) {
      final gpu.Texture msaaColorTexture = gpu.gpuContext.createTexture(
          gpu.StorageMode.deviceTransient,
          size.width.toInt(),
          size.height.toInt(),
          sampleCount: 4,
          enableRenderTargetUsage: true,
          coordinateSystem: gpu.TextureCoordinateSystem.renderToTexture,
      );
      colorAttachment.resolveTexture = colorAttachment.texture;
      colorAttachment.texture = msaaColorTexture;
      colorAttachment.storeAction = gpu.StoreAction.multisampleResolve;
    }
    // specifies how the gpua should store depth and stencil values
    // typically stored in a combined GPU texture. DepthStencilFormat defines
    // how this texture is laid out in memory
    final gpu.Texture depthTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      sampleCount: enableMsaa ? 4 : 1,
      format: gpu.gpuContext.defaultDepthStencilFormat,
      enableRenderTargetUsage: true,
      coordinateSystem: gpu.TextureCoordinateSystem.renderToTexture,
    );
    final renderTarget = gpu.RenderTarget.singleColor(
      colorAttachment,
      depthStencilAttachment: gpu.DepthStencilAttachment(
        texture: depthTexture,
        depthClearValue: 1.0,
      )
    );
    return renderTarget;
  }
}