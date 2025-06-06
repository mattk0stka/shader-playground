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
  int _indexCount = 0;

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

  void ingestVertexData(
      ByteData vertices,
      int vertexCount,
      ByteData? indices, {
      gpu.IndexType indexType = gpu.IndexType.int16,
  }) {

  }



  void bind(vm.Matrix4 modelTransform, vm.Matrix4 cameraTransform, vm.Vector3 cameraPosition);

}