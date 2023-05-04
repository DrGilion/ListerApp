extension ObjectExt<T> on T {
  R let<R>(R block(T it)) => block(this);
}