part of mat3d;

/// A linear interpolation between a beginning and ending Mat3D.
/// Mat3DTween is useful if you want to interpolate across two
/// Mat3D objects. See [Tween] for more information.
/// ```dart
/// final tween = Mat3DTween(
///     begin: Mat3D().scale(0.3),
///     end: Mat3D().translate(50.0)
///   );
/// tween.animate(AnimationController(vsync: vsync));
/// ```
class Mat3DTween extends Tween<Mat3D> {
  /// The begin and end properties must be non-null before the
  /// tween is first used, but the arguments can be null if the
  /// values are going to be filled in later.
  /// ```dart
  /// final tween = Mat3DTween(
  ///     begin: Mat3D().scale(0.3),
  ///     end: Mat3D().translate(50.0)
  ///   );
  /// ```
  Mat3DTween({Mat3D? begin, Mat3D? end}) : super(begin: begin, end: end);

  @override
  Mat3D lerp(double t) {
    final matrix4 = Matrix4Tween(begin: begin?.matrix, end: end?.matrix);
    return Mat3D(matrix: matrix4.lerp(t));
  }
}
