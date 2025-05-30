import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:vector_math/vector_math.dart' as vm;

/*
  - provide a base class with optional implementation
  - share behavior and structure between subclasses
 */
abstract class Geometry {

  gpu.BufferView? _vertices;


  void bind(vm.Matrix4 modelTransform, vm.Matrix4 cameraTransform, vm.Vector3 cameraPosition);

}