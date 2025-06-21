import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:shader_example/domain/model/mesh.dart';
import 'package:vector_math/vector_math.dart';

base class SceneEncoder {

  late final gpu.HostBuffer _transientBuffer;
  SceneEncoder() {
    // default size - 1024 Kb
    _transientBuffer = gpu.gpuContext.createHostBuffer();
  }

  void encode() {
    // if not opaque skipp _encode



  }


}