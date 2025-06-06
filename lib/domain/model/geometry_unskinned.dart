
import 'package:shader_example/domain/model/geometry.dart';
import 'package:vector_math/vector_math.dart';

import 'package:shader_example/shaders.dart';

class GeometryUnskinned extends Geometry {

  GeometryUnskinned() {
    setVertexShader(shaderLibrary['UnskinnedVertex']!);
  }
  @override
  void bind(Matrix4 modelTransform, Matrix4 cameraTransform, Vector3 cameraPosition) {
    // TODO: implement bind
  }


}