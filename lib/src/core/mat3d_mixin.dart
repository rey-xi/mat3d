part of mat3d;

/// Mat3D Base class. Exposes your class to Mat3D operations
/// in other words they can be treated and recognized as one.
/// Sounds great? Thanks to the power of Dart when it comes to
/// Mixins. They are really great at it.
/// ```dart
/// class MyMat3D extends Mat3DMixin<MyMat3D>
///         or with Mat3DMixin<MyMat3D> {
///     ...do the rites...
/// }
/// ```
abstract class Mat3DMixin<T extends Mat3DMixin<T>> implements Mat3D {
  //...Getters
  /// The current bound of mat3D object. the size and offset of
  /// this rect will be used in performing some operations like
  /// scale, rotate, tilt etc. Set this field to change the size
  /// and offset of the Mat3D object.
  @override
  Rect get rect;

  /// The current bound of mat3D object. the size and offset of
  /// this rect will be used in performing some operations like
  /// scale, rotate, tilt etc. Set this field to change the size
  /// and offset of the Mat3D object.
  @override
  set rect(Rect rect);

  /// The base Matrix4 Object that this class wraps. Operations
  /// on objects of this class will be redirected on this object
  /// in a way that it will easily be perfected via rect details.
  @override
  Matrix4 get matrix;

  @override
  Offset get center => rect.center;

  @override
  Float64List get storage => matrix.storage;

  //...Operators
  @override
  T operator -() {
    -Mat3D.from(this);
    return this as T;
  }

  @override
  T operator +(Mat3D other) {
    Mat3D.from(this) + other;
    return this as T;
  }

  @override
  T operator -(Mat3D other) {
    Mat3D.from(this) - other;
    return this as T;
  }

  @override
  T multiply(Mat3D other) {
    Mat3D.from(this).multiply(other);
    return this as T;
  }

  @override
  T translate(double x, [double? y, double? z]) {
    Mat3D.from(this).translate(x, y, z);
    return this as T;
  }

  @override
  T shift(Offset offset, {Offset? origin}) {
    Mat3D.from(this).shift(offset, origin: origin);
    return this as T;
  }

  @override
  T translateX(double offset, {Offset? origin}) {
    Mat3D.from(this).translateX(offset, origin: origin);
    return this as T;
  }

  @override
  T translateY(double offset, {Offset? origin}) {
    Mat3D.from(this).translateY(offset, origin: origin);
    return this as T;
  }

  @override
  T upward(double offset, {Offset? origin}) {
    Mat3D.from(this).upward(offset, origin: origin);
    return this as T;
  }

  @override
  T downward(double offset, {Offset? origin}) {
    Mat3D.from(this).downward(offset, origin: origin);
    return this as T;
  }

  @override
  T forward(
    double offset, {
    Offset? origin,
    direction = TextDirection.ltr,
  }) {
    Mat3D.from(this).forward(
      offset,
      origin: origin,
      direction: direction,
    );
    return this as T;
  }

  @override
  T backward(
    double offset, {
    Offset? origin,
    direction = TextDirection.ltr,
  }) {
    Mat3D.from(this).backward(
      offset,
      origin: origin,
      direction: direction,
    );
    return this as T;
  }

  @override
  T inward(double offset, {Offset? origin}) {
    Mat3D.from(this).inward(offset, origin: origin);
    return this as T;
  }

  @override
  T outward(double offset, {Offset? origin}) {
    Mat3D.from(this).outward(offset, origin: origin);
    return this as T;
  }

  @override
  T translateZ(double offset, {Offset? origin}) {
    Mat3D.from(this).translateZ(offset, origin: origin);
    return this as T;
  }

  @override
  T scale(double x, [double? y, double? z]) {
    Mat3D.from(this).scale(x, y, z);
    return this as T;
  }

  @override
  T scaleX(double ratio, {Offset? origin}) {
    Mat3D.from(this).scaleX(ratio, origin: origin);
    return this as T;
  }

  @override
  T scaleY(double ratio, {Offset? origin}) {
    Mat3D.from(this).scaleY(ratio, origin: origin);
    return this as T;
  }

  @override
  T scaleZ(double ratio, {Offset? origin}) {
    Mat3D.from(this).scaleZ(ratio, origin: origin);
    return this as T;
  }

  @override
  T tilt(double x, double y, [double? z]) {
    Mat3D.from(this).tilt(x, y, z);
    return this as T;
  }

  @override
  T tiltX(double degrees, {Offset? origin}) {
    Mat3D.from(this).tiltX(degrees, origin: origin);
    return this as T;
  }

  @override
  T tiltY(double degrees, {Offset? origin}) {
    Mat3D.from(this).tiltY(degrees, origin: origin);
    return this as T;
  }

  @override
  T tiltZ(double degrees, {Offset? origin}) {
    Mat3D.from(this).tiltZ(degrees, origin: origin);
    return this as T;
  }

  @override
  T rotate(double degrees, {Offset? origin}) {
    Mat3D.from(this).rotate(degrees, origin: origin);
    return this as T;
  }

  @override
  T flipX({Offset? origin}) {
    Mat3D.from(this).flipX(origin: origin);
    return this as T;
  }

  @override
  T flipY({Offset? origin}) {
    Mat3D.from(this).flipY(origin: origin);
    return this as T;
  }

  @override
  Mat3D flipZ({Offset? origin}) {
    Mat3D.from(this).flipY(origin: origin);
    return this as T;
  }

  @override
  String toString() => Mat3D.from(this).toString();
}
