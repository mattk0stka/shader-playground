
import 'dart:typed_data';

import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:shader_example/shaders.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'material.dart';

class UnlitMaterial extends Material {

  late gpu.Texture baseColorTexture;
  vm.Vector4 baseColorFactor = vm.Colors.green;
  double vertexColorWeight = 1.0;


  // constructor
  UnlitMaterial({gpu.Texture? colorTexture}) {
    setFragmentShader(shaderLibrary['UnlitFragment']!);
    baseColorTexture = Material.whitePlaceholder(colorTexture);
  }

  @override
  void bind(gpu.RenderPass pass, gpu.HostBuffer transientsBuffer) {
    super.bind(pass, transientsBuffer);

    var fragInfo = Float32List.fromList([
      baseColorFactor.r, baseColorFactor.g,
      baseColorFactor.b, baseColorFactor.a,
      vertexColorWeight,
    ]);

    pass.bindUniform(
      fragmentShader.getUniformSlot('FragInfo'),
      transientsBuffer.emplace(ByteData.sublistView(fragInfo))
    );

    pass.bindTexture(
      fragmentShader.getUniformSlot('base_color_texture'),
      baseColorTexture,
      sampler: gpu.SamplerOptions(
        widthAddressMode: gpu.SamplerAddressMode.repeat,
        heightAddressMode: gpu.SamplerAddressMode.repeat,
      )
    );
  }
}