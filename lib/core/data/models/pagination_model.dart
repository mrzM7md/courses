class PaginationModel<T> {
  final int currentPage;
  final int totalPages;
  final List<T> data;

  // add fromJsom factory and toJson methods
  factory PaginationModel.fromJson({required Map<String, dynamic> json, required List<T> data}) => PaginationModel(
    currentPage: json['currentPage'],
    totalPages: json['totalPages'],
    data: data,
  );

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'totalPages': totalPages,
    'data': data,
  };

  PaginationModel({required this.currentPage, required this.totalPages, required this.data});
}
