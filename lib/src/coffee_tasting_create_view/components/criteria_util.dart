/// Given a double `value`, rounds to `n` decimal places.
double round(double value, {int n = 1}) {
  return double.parse(value.toStringAsFixed(n));
}
