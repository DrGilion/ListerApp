extension ObjectExt<T extends Object> on T {
  R let<R>(R block(T it)) => block(this);
}
