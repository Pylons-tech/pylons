extension DoubleLerp on double {
  double lerp (double other, double t) => this + (other - this) * t;
}