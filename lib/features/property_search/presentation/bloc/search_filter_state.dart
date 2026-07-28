part of 'search_filter_bloc.dart';

class SearchFilterState extends Equatable {
  final DateTime from;
  final DateTime to;
  final int guests;
  final int minPrice;
  final int maxPrice;

  const SearchFilterState({
    required this.from,
    required this.to,
    required this.guests,
    required this.minPrice,
    required this.maxPrice,
  });

  factory SearchFilterState.initial() {
    final DateTime today = DateTime.now();
    final DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);

    return SearchFilterState(
      from: tomorrow,
      to: tomorrow.add(const Duration(days: 2)),
      guests: 2,
      minPrice: 1000,
      maxPrice: 5000,
    );
  }

  bool get isValid => !to.isBefore(from) && guests > 0 && minPrice <= maxPrice;
  String get fromParam => _formatDate(from);
  String get toParam => _formatDate(to);
  String get priceParam => '$minPrice-$maxPrice';
  String get dateLabel => '${_formatShortDate(from)} - ${_formatShortDate(to)}';
  String get guestLabel => guests == 1 ? '1 guest' : '$guests guests';
  String get priceLabel => '$minPrice-$maxPrice';

  SearchFilterState copyWith({
    final DateTime? from,
    final DateTime? to,
    final int? guests,
    final int? minPrice,
    final int? maxPrice,
  }) {
    return SearchFilterState(
      from: from ?? this.from,
      to: to ?? this.to,
      guests: guests ?? this.guests,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  static String _formatDate(final DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static String _formatShortDate(final DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$month/$day';
  }

  @override
  List<Object?> get props => [from, to, guests, minPrice, maxPrice];
}
