class Meta {
  final int currentPage;
  final int? nextPage;
  final int perPage;
  final int? prevPage;
  final int totalPages;
  final int totalCount;

  Meta({
    required this.currentPage,
    required this.nextPage,
    required this.perPage,
    required this.prevPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      nextPage: json['next_page'],
      perPage: json['per_page'] ?? 10,
      prevPage: json['prev_page'],
      totalPages: json['total_pages'] ?? 1,
      totalCount: json['total_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'next_page': nextPage,
      'per_page': perPage,
      'prev_page': prevPage,
      'total_pages': totalPages,
      'total_count': totalCount,
    };
  }

  @override
  String toString() => 'Meta(page: $currentPage of $totalPages)';
}
