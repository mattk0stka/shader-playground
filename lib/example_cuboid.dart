import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_example/domain/model/mesh.dart';
import 'package:shader_example/domain/model/unlit_material.dart';
import 'package:shader_example/src_engine/camera.dart';
import 'package:shader_example/domain/scene.dart';
import 'package:shader_example/domain/model/cube/cuboid.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'dart:math';


class ExampleCuboid extends StatefulWidget {
  const ExampleCuboid({super.key});

  @override
  State<ExampleCuboid> createState() => _ExampleCuboidState();
}

class _ExampleCuboidState extends State<ExampleCuboid> {


  final CuboidGeometry cuboid = new CuboidGeometry(vm.Vector3(1,1,1,));
  final UnlitMaterial material = new UnlitMaterial();
  late Ticker ticker;
  double elapsedSeconds = 0;

  Scene scene = Scene(mesh: Mesh(geometry: CuboidGeometry(vm.Vector3(1,1,1,)), material: UnlitMaterial()));
  @override
  void initState() {
    ticker = Ticker((elapsed) {
      setState(() {
        elapsedSeconds = elapsed.inMilliseconds.toDouble() / 1000;
      });
    });
    ticker.start();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ScenePainter(scene, elapsedTime: elapsedSeconds));
  }
}


class _ScenePainter extends CustomPainter {
  final double elapsedTime;
  _ScenePainter(this.scene,  {this.elapsedTime = 0});

  Scene scene;
  late Ticker ticker;



  @override
  void paint(Canvas canvas, Size size) {
    final camera = PerspectiveCamera(
      position: vm.Vector3(sin(elapsedTime) * 5, 2, cos(elapsedTime) * 5),
      target: vm.Vector3(0, 0, 0),
    );


    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}