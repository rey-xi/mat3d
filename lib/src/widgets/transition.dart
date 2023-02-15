import 'package:flutter/material.dart';
import 'package:mat3d/mat3d.dart';

class Transition3D extends StatelessWidget {
  //...Fields
  final Mat3D mat3D;
  final Alignment alignment;
  final FilterQuality? filterQuality;
  final Offset? origin;
  final Widget? child;

  const Transition3D({
    super.key,
    required this.mat3D,
    this.alignment = Alignment.center,
    this.filterQuality,
    this.origin,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    //...
    return LayoutBuilder(builder: (context, c) {
      final mat = Mat3D.raw(
        matrix: mat3D.matrix,
        rect: Offset.zero & c.constrain(Size.infinite),
      );
      return Transform(
        transform: mat.matrix,
        alignment: alignment,
        filterQuality: filterQuality,
        origin: origin,
        child: child,
      );
    });
  }
}
