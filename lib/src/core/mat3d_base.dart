part of mat3d;

/// Mat3D Base class. Exposes your class to Mat3D operations
/// in other words they can be treated and recognized as one.
/// Sounds great? Thanks to the power of Dart when it comes to
/// Mixins. They are really great at it.
/// ```dart
/// class MyMat3D extends Mat3DBase<MyMat3D> {
///   MyMat3D(
///      Matrix4 matrix,
///      Offset offset,
///      Size size,
///   ) : super(matrix, rect: offset & size);
/// }
/// ```
abstract class Mat3DBase<T extends Mat3DBase<T>> extends Mat3DMixin<T> {
  //...Getters
  @override
  Rect rect;

  @override
  final Matrix4 matrix;

  /// Override to set [matrix] and optionally [rect]. Acts like
  /// [Mat3D] helper style constructor. Operations on the object
  /// affects [matrix] same way if [matrix] is transformed, it's
  /// changes reflects in the Mat3D object. Yeah, you can easily
  /// transform nonassignable [Matrix4] fields via this very
  /// constructor.
  /// ```dart
  /// class MyMat3D extends Mat3DBase<MyMat3D> {
  ///   MyMat3D(
  ///      Matrix4 matrix,
  ///      Offset offset,
  ///      Size size,
  ///   ) : super(matrix, rect: offset & size);
  /// }
  /// ```
  Mat3DBase(this.matrix, {this.rect = Rect.zero});
}
