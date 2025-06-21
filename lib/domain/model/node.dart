import 'package:vector_math/vector_math.dart' as vm ;

import 'mesh.dart';

/* simple implementation

    node represents a single element in a 3D scene
 */
class Node {

  String name;
  bool visible = true;
  vm.Matrix4 localTransform;
  Mesh mesh;

  Node({this.name = '',  vm.Matrix4? localTransform, required this.mesh}) :
      /*
          null-aware operator - typically appears in a constructor or method
          checks if the variable localTransform is null, if not, it keeps its value other
          it assigns a new identity matrix
       */
      localTransform = localTransform ?? vm.Matrix4.identity();

  /*
      todo: animation
   */

}