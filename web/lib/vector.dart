part of swipe;

class Vector<T extends num> {
  T x;
  T y;

  Vector(T x, T y): this.x = x, this.y = y;

  String toString() => 'Vector($x, $y)';
}
