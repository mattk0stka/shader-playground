import 'package:vector_math/vector_math.dart';

base class Node {

  String name;
  Matrix4 localTransform;

  /*
    - named paramters ({})
    - name must be provided
    - localTransform is optional and nullable
   */
  Node({required this.name, Matrix4? localTransform})
    // initializer list: values are assigned before the constructor body runs
    // if matrix provided use it, if not assign default identity matrix.
      : localTransform = localTransform ?? Matrix4.identity();

}