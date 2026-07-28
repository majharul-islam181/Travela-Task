class JsonReaders {
  JsonReaders._();

  static int readInt(final dynamic value, {final int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int? readNullableInt(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static double readDouble(final dynamic value, {final double fallback = 0}) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double? readNullableDouble(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static num readNum(final dynamic value, {final num fallback = 0}) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static num? readNullableNum(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value;
    }
    return num.tryParse(value.toString());
  }
}
