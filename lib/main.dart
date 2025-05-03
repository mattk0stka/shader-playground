import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'shaders.dart';
import 'colors.dart';

import 'dart:typed_data';

void main() => runApp(ShaderExample());

class ShaderExample extends StatelessWidget {
  const ShaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double red = 1.0;
  double green = 1.0;
  double blue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //body: Center(child: const Text('some text here'),),
      /*
      body: CustomPaint(
        painter: TrianglePainter(),
      )
       */

      body: CustomPaint(
        painter: ColorsPainter(red, green, blue),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    final gpu.Texture? texture = gpu.gpuContext.createTexture(
        gpu.StorageMode.devicePrivate, 300, 300,
        enableRenderTargetUsage: true,);
        //enableShaderReadUsage: true,);
       // coordinateSystem: gpu.TextureCoordinateSystem.renderToTexture);
    if (texture == null) {
      return;
    }



    final renderTarget = gpu.RenderTarget.singleColor(
        //gpu.ColorAttachment(texture: texture, clearValue: Colors.lightBlue));
        gpu.ColorAttachment(texture: texture));

    /*
      Tile memory is a concept used primarily in graphics hardware to optimize
       rendering performance and memory useage, especially when dealing with large
       framebuffer or high-resolution images.

       Tile memory refers to a small, fast memory buffer, used to temporarily store
       a portion of a framebuffer or render target, usually corresponding to a tile,
       which is a small rectangular block of the full screen or image.
     */



    /*
      render pass: a single iteration through the rendering pipeline that processes a
      scene to produce image data, typically to a framebuffer or texture.
     */
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);

    final vert = shaderLibrary['SimpleVertex']!;
    final frag = shaderLibrary['SimpleFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    final vertices = Float32List.fromList([
      -0.5, -0.5, // First vertex
      0.5, -0.5, // Second vertex
      0.0,  0.5, // Third vertex
    ]);
    final verticesDeviceBuffer = gpu.gpuContext
        .createDeviceBufferWithCopy(ByteData.sublistView(vertices))!;

    renderPass.bindPipeline(pipeline);
    final verticesView = gpu.BufferView(
      verticesDeviceBuffer,
      offsetInBytes: 0,
      lengthInBytes: verticesDeviceBuffer.sizeInBytes,
    );
    renderPass.bindVertexBuffer(verticesView, 3);

    renderPass.draw();
    commandBuffer.submit();

    final image = texture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
