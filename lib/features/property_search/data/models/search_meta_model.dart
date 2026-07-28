import '../../../../core/utils/json_readers.dart';
import '../../domain/entities/search_meta.dart';

class SearchMetaModel extends SearchMeta {
  const SearchMetaModel({
    required super.totalCount,
    required super.page,
    required super.perPage,
    super.nextPage,
    super.totalPage,
  });

  factory SearchMetaModel.fromJson(final Map<String, dynamic> json) {
    final dynamic rawPagination = json['pagination'];
    final Map<String, dynamic> pagination =
        rawPagination is Map<String, dynamic> ? rawPagination : const {};

    return SearchMetaModel(
      totalCount: JsonReaders.readInt(
        json['total_count'] ?? pagination['total_count'],
      ),
      page: JsonReaders.readInt(pagination['page'], fallback: 1),
      perPage: JsonReaders.readInt(pagination['limit'], fallback: 20),
      nextPage: JsonReaders.readNullableInt(pagination['next']),
      totalPage: JsonReaders.readNullableInt(pagination['total_page']),
    );
  }
}
