import 'package:equatable/equatable.dart';

class SearchMeta extends Equatable {
  final int totalCount;
  final int page;
  final int perPage;
  final int? nextPage;
  final int? totalPage;

  const SearchMeta({
    required this.totalCount,
    required this.page,
    required this.perPage,
    this.nextPage,
    this.totalPage,
  });

  @override
  List<Object?> get props => [totalCount, page, perPage, nextPage, totalPage];
}
