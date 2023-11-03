import 'dart:io';

// import 'package:intl/intl.dart';

extension StringExtensions on String? {
  String get capitalize => '${this![0].toUpperCase()}${this!.substring(1)}';
  String get capitalizeFirstOfEach => this!.split(' ').map((str) => str.capitalize).join(' ');
  String get removeHtmlTags => this!.replaceAll(RegExp(r'<[^>]*>'), '');
  String get replaceSpaces => this!.replaceAll(' ', '_');
  String get formatDuration {
    final duration = Duration(milliseconds: int.parse(this!));
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  File get toFile => File(this!);

  String get formatFromFB {
    final split = this!.split('-');
    return split[1] + split[2];
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String get removeHash => this!.replaceAll('#', '');

  bool matches(String value) =>
      this!.toLowerCase().startsWith(value) || this!.toLowerCase().contains(value);

  String get errorToPresentableString =>
      this!.replaceAll('-', ' ').replaceFirst(this![0], this![0].toUpperCase());

  bool containOrStartWith(String query) =>
      this!.toLowerCase().contains(query.toLowerCase()) ||
      this!.toLowerCase().startsWith(query.toLowerCase());

}
