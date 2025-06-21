
import 'package:shader_example/domain/model/geometry.dart';
import 'package:shader_example/domain/model/material.dart';

base class MeshPrimitive {

  Geometry geometry;
  Material material;

  // Constructor
  MeshPrimitive({required this.geometry, required this.material});
}

base class Mesh {

  final List<MeshPrimitive> primitves;

  Mesh({required Geometry geometry, required Material material}) :
      primitves = [MeshPrimitive(geometry: geometry, material: material)];

  // render some stuff

}