import 'dart:typed_data';

import 'package:shader_example/domain/model/geometry_unskinned.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:flutter_gpu/gpu.dart' as gpu;

class CuboidGeometry extends GeometryUnskinned {

  CuboidGeometry(vm.Vector3 extents) {
    final e = extents / 2;

    // set coordinates (position, normal, uv, color)
    final vertices = Float32List.fromList(<double>[
      -e.x, -e.y, -e.z, /* */ 0, 0, -1, /* */ 0, 0, /* */ 1, 0, 0, 1, //
      e.x, -e.y, -e.z, /*  */ 0, 0, -1, /* */ 1, 0, /* */ 0, 1, 0, 1, //
      e.x, e.y, -e.z, /*   */ 0, 0, -1, /* */ 1, 1, /* */ 0, 0, 1, 1, //
      -e.x, e.y, -e.z, /*  */ 0, 0, -1, /* */ 0, 1, /* */ 0, 0, 0, 1, //
      -e.x, -e.y, e.z, /*  */ 0, 0, -1, /* */ 0, 0, /* */ 0, 1, 1, 1, //
      e.x, -e.y, e.z, /*   */ 0, 0, -1, /* */ 1, 0, /* */ 1, 0, 1, 1, //
      e.x, e.y, e.z, /*    */ 0, 0, -1, /* */ 1, 1, /* */ 1, 1, 0, 1, //
      -e.x, e.y, e.z, /*   */ 0, 0, -1, /* */ 0, 1, /* */ 1, 1, 1, 1, //
    ]);

    // set indices
    final indices = Uint16List.fromList(<int>[
      0, 1, 3, 3, 1, 2, //
      1, 5, 2, 2, 5, 6, //
      5, 4, 6, 6, 4, 7, //
      4, 0, 7, 7, 0, 3, //
      3, 2, 7, 7, 2, 6, //
      4, 5, 0, 0, 5, 1, //
    ]);

    /*
      ByteData.sublistView
      is a static method to efficiently create a view of a portion of a ByteData buffer
      useful for working with binary data in performance-sensitive application such as:
        - decoding/encoding files
        - network protocols
        - interfacing with native code via FFI

      Reasons to use ByteData
        - Endianness Control -> floatByteData.getFloat32(offset, Endian.little);
        - byte-level manipulation
        - interleaved or packed data [float, int, float]
        - ffi or platform interop
     */

   ingestVertexData(
       ByteData.sublistView(vertices),
       8,
       ByteData.sublistView(indices),
       indexType: gpu.IndexType.int16
   );

  }
}