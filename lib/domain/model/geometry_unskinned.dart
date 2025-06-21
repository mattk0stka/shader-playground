
import 'dart:typed_data';

import 'package:shader_example/domain/model/geometry.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;

import 'package:shader_example/shaders.dart';

class GeometryUnskinned extends Geometry {

  // Constructor - set only vertexShader
  GeometryUnskinned() {
    setVertexShader(shaderLibrary['UnskinnedVertex']!);
  }

  @override
  void bind(
      gpu.RenderPass pass,
      gpu.HostBuffer transientsBuffer,
      Matrix4 modelTransform,
      Matrix4 cameraTransform,
      Vector3 cameraPosition
      ) {
    if (vertices == null) {
      throw Exception('setVertices must be called before getBufferView for Geometry');
    }

    // bind vertex buffer
    pass.bindVertexBuffer(vertices, vertexCount);

    if (indices != null) {
      // indexType should be variable
      pass.bindIndexBuffer(indices!, gpu.IndexType.int16, indexCount);
    }

    final frameInfoSlot = vertexShader.getUniformSlot('FrameInfo');
    final frameInfoFloats = Float32List.fromList([
      modelTransform.storage[0],
      modelTransform.storage[1],
      modelTransform.storage[2],
      modelTransform.storage[3],
      modelTransform.storage[4],
      modelTransform.storage[5],
      modelTransform.storage[6],
      modelTransform.storage[7],
      modelTransform.storage[8],
      modelTransform.storage[9],
      modelTransform.storage[10],
      modelTransform.storage[11],
      modelTransform.storage[12],
      modelTransform.storage[13],
      modelTransform.storage[14],
      modelTransform.storage[15],
      cameraTransform.storage[0],
      cameraTransform.storage[1],
      cameraTransform.storage[2],
      cameraTransform.storage[3],
      cameraTransform.storage[4],
      cameraTransform.storage[5],
      cameraTransform.storage[6],
      cameraTransform.storage[7],
      cameraTransform.storage[8],
      cameraTransform.storage[9],
      cameraTransform.storage[10],
      cameraTransform.storage[11],
      cameraTransform.storage[12],
      cameraTransform.storage[13],
      cameraTransform.storage[14],
      cameraTransform.storage[15],
      cameraPosition.x,
      cameraPosition.y,
      cameraPosition.z,
    ]);

    /*
        append byte data to the end of the HostBuffer and produce a BufferView
        that references the new data in the buffer
     */
    final frameInfoView = transientsBuffer.emplace(
      frameInfoFloats.buffer.asByteData(),
    );

    pass.bindUniform(frameInfoSlot, frameInfoView);
  }
}