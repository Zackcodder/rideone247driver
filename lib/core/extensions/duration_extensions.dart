extension DurationExtensions on Duration? {
  String get format => this == null ? '00:00:00' : ('$this'.split('.')[0].padLeft(8, '0'));
}
