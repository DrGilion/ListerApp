/// extension for every object
extension ObjectExt<T extends Object> on T {
  /// transform the receiver of type [T] to an object of type [R].
  R let<R>(R block(T it)) => block(this);
}
