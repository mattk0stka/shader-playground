import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:vector_math/vector_math.dart' as vm;
import 'dart:typed_data';

/*
  - provide a base class with optional implementation
  - share behavior and structure between subclasses
 */
abstract class Geometry {

  // reference to a byte range within a gpu-resident buffer
  gpu.BufferView? _vertices;
  int _vertexCount = 0;

  gpu.BufferView? _indices;
  gpu.IndexType _indexType = gpu.IndexType.int16;
  int _indexCount = 0;

  // responsible for vertex shader
  gpu.Shader? _vertexShader;
  gpu.Shader get vertexShader {
    if (_vertexShader == null) {
      throw Exception('vertex shader has not been set');
    }
    return _vertexShader!;
  }

  void setVertexShader(gpu.Shader shader) {
    _vertexShader = shader;
  }

  void setVertices(gpu.BufferView vertices, int vertexCount) {
    _vertices = vertices;
    _vertexCount = vertexCount;
  }

  gpu.BufferView get vertices {
    if (_vertices == null) {
      throw  Exception('geometry vertices not set, plz do it before using getter method');
    }
    return _vertices!;
  }

  int get vertexCount {
    return _vertexCount;
  }

  gpu.BufferView? get indices {
    return _indices;
  }

  int get indexCount {
    return _indexCount;
  }

  void setIndices(gpu.BufferView indices, gpu.IndexType indexType) {
    _indices = indices;
    _indexType = indexType;
    switch (indexType) {
      case gpu.IndexType.int16:
        _indexCount = indices.lengthInBytes ~/ 2;
      case gpu.IndexType.int32:
        _indexCount = indices.lengthInBytes ~/4 ;
    }
  }

  void ingestVertexData(
      ByteData vertices,
      int vertexCount,
      ByteData? indices, {
      gpu.IndexType indexType = gpu.IndexType.int16,
  }) {
    // allocates a new region of host-visible gpu-resident memory
    gpu.DeviceBuffer deviceBuffer = gpu.gpuContext.createDeviceBuffer(
      gpu.StorageMode.hostVisible,
      indices == null
        ? vertices.lengthInBytes
        : vertices.lengthInBytes + indices.lengthInBytes,
    );

    deviceBuffer.overwrite(vertices, destinationOffsetInBytes: 0);

    setVertices(gpu.BufferView(
      deviceBuffer,
      offsetInBytes: 0,
      lengthInBytes: vertices.lengthInBytes,
    ),
      vertexCount
    );

    // position indices immediately after the vertices in the memory.
    if (indices != null) {
      deviceBuffer.overwrite(
        indices,
        destinationOffsetInBytes: vertices.lengthInBytes,
      );
      setIndices(gpu.BufferView(
          deviceBuffer,
          offsetInBytes: vertices.lengthInBytes,
          lengthInBytes: indices.lengthInBytes
      ), indexType);
    }
  }

  void setJointsTexture(gpu.Texture? texture, int width) {}

  void bind(
      gpu.RenderPass pass,
      gpu.HostBuffer transientsBuffer,
      vm.Matrix4 modelTransform,
      vm.Matrix4 cameraTransform,
      vm.Vector3 cameraPosition
      );

}