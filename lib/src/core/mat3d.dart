library mat3d;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

part 'mat3d_base.dart';
part 'mat3d_mixin.dart';
part 'mat3d_tween.dart';

/// ## 3D Matrix class
/// A 3D matrix class. A wrapper class for the original 4D
/// [Matrix4]. It makes it easy to perform 3D basic operations.
/// It's majorly a preparation class for future Rey projects -
/// Shapes and Spatial. Basically the way it works, you create
/// a mat3D optionally with an initial Matrix4 data which won't
/// be affected by operations on the Mat3D object except in some
/// cases. You can get the matrix back via [matrix] and in other
/// to update the Mat3D's size and offset, reassign [rect].
/// ```dart
/// final mat3D = Mat3D(myMatrix, myRect)
/// mat3D.scale(1).shift(qp.o(2));
/// print(mat3D); [..storage](..rect)
/// ```
class Mat3D {
  //...Fields
  /// The current bound of mat3D object. the size and offset of
  /// this rect will be used in performing some operations like
  /// scale, rotate, tilt etc. Set this field to change the size
  /// and offset of the Mat3D object.
  Rect rect;

  /// The base Matrix4 Object that this class wraps. Operations
  /// on objects of this class will be redirected on this object
  /// in a way that it will easily be perfected via rect details.
  final Matrix4 matrix;

  /// This constructor ensures that [matrix] source is immune
  /// to changes on [Mat3D.matrix]. Don't consider using this
  /// constructor if the aim is to use this class as an helper
  /// class, use [Mat3D.raw] instead. [rect] is default value
  /// is [Rect.zero]. If matrix is null, [Matrix4.identity] will
  /// be used instead.
  /// ```dart
  /// final mat3D = Mat3D(myMatrix, myRect)
  /// print(mat3D); [..storage](..rect)
  /// ```
  Mat3D({Matrix4? matrix, this.rect = Rect.zero}) //~
      : matrix = matrix?.clone() ?? Matrix4.identity();

  /// The helper style constructor for Mat3D. operations on the
  /// object affects [matrix] same way if [matrix] is transformed,
  /// it's changes reflects in the Mat3D object. Yeah, you can
  /// easily transform nonassignable [Matrix4] fields via this
  /// very constructor.
  /// ```dart
  /// final mat3D = Mat3D.raw(myMatrix, myRect)
  /// print(mat3D); [..storage](..rect)
  /// ```
  Mat3D.raw({required this.matrix, this.rect = Rect.zero});

  /// The helper style constructor for Mat3D. operations on the
  /// object affects [matrix] same way if [matrix] is audited,
  /// it's changes reflects in the Mat3D object. Yeah, you can
  /// easily audit Nonassignable [Matrix4] fields via this very
  /// constructor.
  /// ```dart
  /// final mat3D = Mat3D.from(myMat3D)
  /// print(mat3D); [..storage](..rect)
  /// ```
  factory Mat3D.from(Mat3D mat3D) {
    //...
    return Mat3D.raw(
      matrix: mat3D.matrix,
      rect: mat3D.rect,
    );
  }

  factory Mat3D.parse(String source) {
    final regex = RegExp(r'Mat3D(\[[0-9., ]+\])\(([0-9.]+), ?'
        r'([0-9.]+), ?([0-9.]+), ?([0-9.]+),? ?\)');
    final match = regex.matchAsPrefix(source);
    if (match != null) {
      final l = double.tryParse(match.group(2) ?? '0') ?? 0;
      final t = double.tryParse(match.group(3) ?? '0') ?? 0;
      final r = double.tryParse(match.group(4) ?? '0') ?? 0;
      final b = double.tryParse(match.group(5) ?? '0') ?? 0;
      final list = jsonDecode(match.group(1) ?? 'null') as List<num>?;
      if (list == null) return Mat3D(rect: Rect.fromLTRB(l, t, r, b));
      final storage = list.map((e) => e.toDouble()).toList();
      return Mat3D(
        matrix: Matrix4.fromFloat64List(Float64List.fromList(storage)),
        rect: Rect.fromLTRB(l, t, r, b),
      );
    }
    return Mat3D();
  }

  /// The helper style constructor for Mat3D. Combine multiple
  /// mat3D models creating a new compound mat3D model.
  /// constructor.
  /// ```dart
  /// final mat3D = Mat3D.combine([myMat3D])
  /// print(mat3D); [..storage](..rect)
  /// ```
  factory Mat3D.combine(List<Mat3D> mat3D) {
    return mat3D.fold<Mat3D>(Mat3D(), (p, e) => p.multiply(e));
  }

  //...Getter
  /// Locates the center of the Mat3D object ie. the center of
  /// it's rect value. This is the default value of all origin
  /// fields during any transformation or operations.
  Offset get center => rect.center;

  /// Yeah! You can convert mat3D directly to [Float64List] as
  /// the storage that represents the containing [matrix]. Same
  /// as calling [Matrix4.storage].
  Float64List get storage => matrix.storage;

  //...Operators
  /// Transpose the Mat3D object. Same as [Matrix4.transpose]
  /// ```dart
  /// final mat3D = Mat3D().scaleX(2.0);
  /// print(-ma3D == mat3D..matrix.transpose()); // true
  /// ```
  Mat3D operator -() => this..matrix.transpose();

  /// Add Mat3D object to [other].
  /// ```dart
  /// final mat3D = Mat3D().scaleX(2.0);
  /// final mat3D2 = Mat3D().translate(50.0);
  /// print(mat3D + mat3D2);
  /// ```
  Mat3D operator +(covariant Mat3D other) {
    final d = other.center - center;
    rect = rect.shift(d).expandToInclude(other.rect);
    return this..matrix.add(other.matrix);
  }

  /// Subtract Mat3D object from [other].
  /// ```dart
  /// final mat3D = Mat3D().scaleX(2.0);
  /// final mat3D2 = Mat3D().translate(50.0);
  /// print(mat3D - mat3D2);
  /// ```
  Mat3D operator -(covariant Mat3D other) {
    final d = other.center - center;
    rect = rect.shift(d).expandToInclude(other.rect);
    return this..matrix.sub(other.matrix);
  }

  //...Methods
  /// Vector multiply Mat3D object by [other].
  /// ```dart
  /// final mat3D = Mat3D().scaleX(2.0);
  /// final mat3D2 = Mat3D().translate(50.0);
  /// print(mat3D.multiply(mat3D2));
  /// ```
  Mat3D multiply(covariant Mat3D other) {
    final d = other.center - center;
    rect = rect.shift(d).expandToInclude(other.rect);
    return this..matrix.multiply(other.matrix); //...*
  }

  /// Translate Mat3D object in three dimensions over [x], [y],
  /// and [z]. [y] defaults to [x] and [z] defaults to 0.0. Same
  /// as [Matrix4.leftTranslate]
  /// ```dart
  /// final mat = Mat3D().translate(10.5);
  /// mat.translate(10.5);
  /// print(mat); // translate 21.0
  /// ```
  Mat3D translate(double x, [double? y, double? z]) {
    final origin = center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..leftTranslate(x, y ?? x, z ?? 0.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Translate Mat3D object in two dimensions over [offset].
  /// Same as [Matrix4.leftTranslate]   but in two dimensions
  /// ```dart
  /// final mat = Mat3D().shift(Offset(24.4, 24.4));
  /// mat.shift(Offset(24.4, 24.4)).translate(-12.0);
  /// print(mat); // shift Offset(36.8, 36.8)
  /// ```
  Mat3D shift(Offset offset, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..leftTranslate(offset.dx, offset.dy, 0.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Translate Mat3D object around X axis over [offset]
  /// ```dart
  /// final mat = Mat3D().translateX(24.4);
  /// mat.translateX(24.4).translateX(-12.0);
  /// print(mat); // translateX 36.8
  /// ```
  Mat3D translateX(double offset, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..leftTranslate(offset, 0.0, 0.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Translate Mat3D object around Y axis over [offset]
  /// ```dart
  /// final mat = Mat3D().translateY(24.4);
  /// mat.translateY(24.4).translateY(-12.0);
  /// print(mat); // translateY 36.8
  /// ```
  Mat3D translateY(double offset, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..leftTranslate(0.0, offset, 0.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Translate Mat3D object around Z axis over [offset]
  /// ```dart
  /// final mat = Mat3D().translateZ(24.4);
  /// mat.translateZ(24.4).translateZ(-12.0);
  /// print(mat); // translateZ 36.8
  /// ```
  Mat3D translateZ(double offset, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..leftTranslate(0.0, 0.0, offset)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Translate Mat3D object upward over [offset]
  /// ```dart
  /// final mat = Mat3D().upward(24.4);
  /// mat.upward(24.4).upward(-12.0);
  /// print(mat); // upward 36.8
  /// ```
  Mat3D upward(double offset, {Offset? origin}) {
    return translateY(-offset, origin: origin);
  }

  /// Translate Mat3D object downward  over [offset]
  /// ```dart
  /// final mat = Mat3D().downward(24.4);
  /// mat.downward(24.4).downward(-12.0);
  /// print(mat); // downward 36.8
  /// ```
  Mat3D downward(double offset, {Offset? origin}) {
    return translateY(offset, origin: origin);
  }

  /// Translate Mat3D object forward over [offset]
  /// ```dart
  /// final mat = Mat3D().forward(24.4);
  /// mat.forward(24.4).forward(-12.0);
  /// print(mat); // forward 36.8
  /// ```
  Mat3D forward(
    double offset, {
    Offset? origin,
    TextDirection direction = TextDirection.ltr,
  }) {
    if (direction == TextDirection.ltr) {
      return translateX(offset, origin: origin);
    }
    return translateX(-offset, origin: origin);
  }

  /// Translate Mat3D object reverse over [offset]
  /// ```dart
  /// final mat = Mat3D().reverse(24.4);
  /// mat.reverse(24.4).reverse(-12.0);
  /// print(mat); // reverse 36.8
  /// ```
  Mat3D backward(
    double offset, {
    Offset? origin,
    TextDirection direction = TextDirection.ltr,
  }) {
    if (direction == TextDirection.ltr) {
      return translateX(-offset, origin: origin);
    }
    return translateX(offset, origin: origin);
  }

  /// Translate Mat3D object inward over [offset]
  /// ```dart
  /// final mat = Mat3D().inward(24.4);
  /// mat.inward(24.4).inward(-12.0);
  /// print(mat); // inward 36.8
  /// ```
  Mat3D inward(double offset, {Offset? origin}) {
    return translateZ(-offset, origin: origin);
  }

  /// Translate Mat3D object outward over [offset]
  /// ```dart
  /// final mat = Mat3D().outward(24.4);
  /// mat.outward(24.4).outward(-12.0);
  /// print(mat); // outward 36.8
  /// ```
  Mat3D outward(double offset, {Offset? origin}) {
    return translateZ(offset, origin: origin);
  }

  /// Scale Mat3D object in three dimensions by [x] around
  /// X axis, [y] around Y axis, and [z] around Z axis.
  /// [y] defaults to [x]. [z] defaults to 1.0
  /// ```dart
  /// final mat = Mat3D().scale(2.5);
  /// mat.scale(2.5);
  /// print(mat); // scale 4.25
  /// ```
  Mat3D scale(double x, [double? y, double? z]) {
    matrix
      ..translate(center.dx, center.dy)
      ..scale(x, y ?? x, z ?? 1.0)
      ..translate(-center.dx, -center.dy);
    return this;
  }

  /// Scale Mat3D object around X axis by [ratio]. [origin] is
  /// treated as scaling pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().scaleX(2.5);
  /// mat.scaleX(2.5)
  /// print(mat); // scaleX 4.25
  /// ```
  Mat3D scaleX(double ratio, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..scale(ratio, 1.0, 1.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Scale Mat3D object around Y axis by [ratio]. [origin] is
  /// treated as scaling pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().scaleY(2.5);
  /// mat.scaleY(2.5)
  /// print(mat); // scaleY 4.25
  /// ```
  Mat3D scaleY(double ratio, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..scale(1.0, ratio, 1.0)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Scale Mat3D object around Z axis by [ratio]. [origin] is
  /// treated as scaling pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().scaleZ(2.5);
  /// mat.scaleZ(2.5)
  /// print(mat); // scaleZ 4.25
  /// ```
  Mat3D scaleZ(double ratio, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..scale(1.0, 1.0, ratio)
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Rotate Mat3D object in three dimensions over [x] around
  /// X axis, [y] around Y axis, and [z] around Z axis. [y]
  /// defaults to [x] and [z] defaults to 0.0; The values of
  /// [x], [y] and [z] are in degrees. range: 0º to 360º
  /// ```dart
  /// final mat = Mat3D().tilt(60);
  /// mat.tilt(30);
  /// print(mat); // tilt 90
  /// ```
  Mat3D tilt(double x, double y, [double? z]) {
    tiltX(x).tiltY(y).tiltZ(z ?? 0.0);
    return this;
  }

  /// Tilt Mat3D object around X axis over [degrees]. [origin]
  /// act as the rotation pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().tiltX(30);
  /// mat.tiltX(15)
  /// print(mat); // tiltX 45
  /// ```
  Mat3D tiltX(double degrees, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..multiply(Matrix4.rotationX(pi * degrees / 180))
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Tilt Mat3D object around Y axis over [degrees]. [origin]
  /// act as the rotation pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().tiltY(30);
  /// mat.tiltY(15)
  /// print(mat); // tiltY 45
  /// ```
  Mat3D tiltY(double degrees, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..multiply(Matrix4.rotationY(pi * degrees / 180))
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Tilt Mat3D object around Z axis over [degrees]. [origin]
  /// act as the rotation pivot. [origin] defaults to [center]
  /// ```dart
  /// final mat = Mat3D().tiltZ(30);
  /// mat.tiltZ(15)
  /// print(mat); // tiltZ 45
  /// ```
  Mat3D tiltZ(double degrees, {Offset? origin}) {
    rotate(degrees, origin: origin);
    return this;
  }

  /// Rotate Mat3D object over [degrees] on two dimensional level.
  /// Same as [tiltZ]. [origin] act as the rotation pivot. [origin]
  /// defaults to [center].
  /// ```dart
  /// final mat = Mat3D().tiltZ(30);
  /// mat.tiltZ(15)
  /// print(mat); // tiltZ 45
  /// ```
  Mat3D rotate(double degrees, {Offset? origin}) {
    origin ??= center - rect.topLeft;
    matrix
      ..translate(origin.dx, origin.dy)
      ..multiply(Matrix4.rotationZ(pi * degrees / 180))
      ..translate(-origin.dx, -origin.dy);
    return this;
  }

  /// Flip Mat3D object over X Axis. Left becomes Right and Vice
  /// Versa. Same as [tiltX] with 180 degrees and [origin] which
  /// defaults to [center].
  /// ```dart
  /// final mat = Mat3D().flipX();
  /// print(mat); // tiltX 180
  /// ```
  Mat3D flipX({Offset? origin}) => tiltX(180, origin: origin);

  /// Flip Mat3D object over Y Axis. Left becomes Right and Vice
  /// Versa. Same as [tiltY] with 180 degrees and [origin] which
  /// defaults to [center].
  /// ```dart
  /// final mat = Mat3D().flipY();
  /// print(mat); // tiltY 180
  /// ```
  Mat3D flipY({Offset? origin}) => tiltY(180, origin: origin);

  /// Flip Mat3D object over Z Axis. Left becomes Right and Vice
  /// Versa. Same as [tiltZ] with 180 degrees and [origin] which
  /// defaults to [center].
  /// ```dart
  /// final mat = Mat3D().flipZ();
  /// print(mat); // tiltZ 180
  /// ```
  Mat3D flipZ({Offset? origin}) => tiltZ(180, origin: origin);

  @override
  String toString() => 'Mat3D$storage(${rect.left}, ${rect.top}'
      ', ${rect.right}, ${rect.bottom})';
}
