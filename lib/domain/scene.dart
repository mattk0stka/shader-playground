import 'package:flutter/cupertino.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'dart:ui' as ui;

import 'package:vector_math/vector_math.dart' as vm;
import '../src_engine/camera.dart';
import 'model/mesh.dart';
import 'model/geometry.dart';
import 'model/material.dart';

enum AntiAliasingMode {none, msaa }

class Scene {

  final Mesh mesh;
  final List<gpu.RenderTarget> _renderTargets = [];

  gpu.CommandBuffer? _commandBuffer;
  gpu.HostBuffer? _transientBuffer;
  gpu.RenderPass? _renderPass;
  // default disabled
  AntiAliasingMode _antiAliasingMode = AntiAliasingMode.none;
  // todo: method that ensures all necessary resources are loaded and ready
  Scene({required this.mesh}) {
    // try to set msaa
    antiAliasingMode = AntiAliasingMode.msaa;
    /*
    _commandBuffer = gpu.gpuContext.createCommandBuffer();
    _transientBuffer = gpu.gpuContext.createHostBuffer();
     */

  }

  set antiAliasingMode(AntiAliasingMode value) {
    switch (value) {
      case AntiAliasingMode.none:
        // do nothing
        break;
      case AntiAliasingMode.msaa:
        if (!gpu.gpuContext.doesSupportOffscreenMSAA) {
          debugPrint('msaa is not currently supported on this backend');
          // msaa not supported - leave function without changes
          return;
        }
        break;
    }
    _antiAliasingMode = value;
  }

  AntiAliasingMode get antiAliasingMode {
    return _antiAliasingMode;
  }

  void render(Camera camera, ui.Canvas canvas, {ui.Rect? viewport}) {
    final drawArea = viewport ?? canvas.getLocalClipBounds();

    if (drawArea.isEmpty) {
      debugPrint('drawArea ist emptry');
      return;
    }

    final enableMsaa = _antiAliasingMode == AntiAliasingMode.msaa;
    if (_renderTargets.length == 0) {
      //final gpu.RenderTarget renderTarget = getRenderTarget(drawArea.size, enableMsaa);
      _renderTargets.add(getRenderTarget(drawArea.size, enableMsaa));
    }
    final gpu.RenderTarget renderTarget = _renderTargets[0];

    // _renderPass
    _commandBuffer = gpu.gpuContext.createCommandBuffer();
    _transientBuffer = gpu.gpuContext.createHostBuffer();
    _renderPass = _commandBuffer!.createRenderPass(renderTarget);
    _renderPass!.setDepthWriteEnable(true);
    _renderPass!.setColorBlendEnable(false);
    _renderPass!.setDepthCompareOperation(gpu.CompareFunction.lessEqual);

    encoder(camera, drawArea.size, vm.Matrix4.identity(), mesh.primitves[0].geometry, mesh.primitves[0].material);

    final gpu.Texture texture =
    enableMsaa
        ? renderTarget.colorAttachments[0].resolveTexture!
        : renderTarget.colorAttachments[0].texture;

    final image = texture.asImage();
    canvas.drawImage(image, drawArea.topLeft, ui.Paint());
  }

  void encoder(Camera camera,  ui.Size dimensions, vm.Matrix4 worldTransform, Geometry geometry, Material material) {
    // refactor finish
    {
      _renderPass!.setDepthWriteEnable(false);
      _renderPass!.setColorBlendEnable(true);
      _renderPass!.setColorBlendEquation(
        gpu.ColorBlendEquation(
          colorBlendOperation: gpu.BlendOperation.add,
          sourceColorBlendFactor: gpu.BlendFactor.one,
          destinationColorBlendFactor: gpu.BlendFactor.oneMinusSourceAlpha,
          alphaBlendOperation: gpu.BlendOperation.add,
          sourceAlphaBlendFactor: gpu.BlendFactor.one,
          destinationAlphaBlendFactor: gpu.BlendFactor.oneMinusSourceAlpha,
        ),
      );
    }


    { // refactor encode
      _renderPass!.clearBindings();
      var pipeline = gpu.gpuContext.createRenderPipeline(
          geometry.vertexShader,
          material.fragmentShader
      );

      _renderPass!.bindPipeline(pipeline);
      geometry.bind(
          _renderPass!,
          _transientBuffer!,
          worldTransform,
          camera.getViewTransform(dimensions),
          camera.position
      );

      material.bind(
        _renderPass!,
        _transientBuffer!,
      );

      _renderPass!.draw();
    }

    _commandBuffer!.submit();
    _transientBuffer!.reset();
  }


  /*
    todo: refactor
   */
  gpu.RenderTarget getRenderTarget(ui.Size size, bool enableMsaa) {
    debugPrint('size: ${size.width}');
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
    // specifies how the gpu should store depth and stencil values
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