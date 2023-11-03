// import 'package:intl/intl.dart';

// extension DateTimeExtension on DateTime? {
//   String get format {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final date = DateTime(this!.year, this!.month, this!.day);
//     if (date == today) {
//       return 'Today, ${DateFormat('hh:mm a').format(this!)}';
//     } else {
//       return DateFormat('MMM dd, yyyy').format(this!);
//     }
//   }

//   String get time {
//     return DateFormat('hh:mm a').format(this!);
//   }

//   String get date{
//     return DateFormat('MMM dd, yyyy').format(this!);
//   }

//   String get completeFormat {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final date = DateTime(this!.year, this!.month, this!.day);
//     if (date == today) {
//       return 'Today ${DateFormat('hh:mm a').format(this!)}';
//     } else {
//       return DateFormat('MMM dd, hh:mm a').format(this!);
//     }
//   }

//   /// if the date is before the current date or null, it will return the current date
//   /// else it will return the date
//   DateTime get get {
//     if (this == null || this!.isBefore(DateTime.now())) {
//       return DateTime.now().add(const Duration(seconds: 10));
//     }
//     return this!;
//   }

//   bool isSameAs(DateTime other) {
//     return this!.year == other.year && this!.month == other.month && this!.day == other.day;
//   }
// }
