class ParsecEvalException implements Exception {
  String cause;
  ParsecEvalException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
