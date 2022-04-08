class BookDetail {
  BookDetail(
    this._bookDetail, {
    required List<String> bookDetail,
  }) {
    _bookDetail = bookDetail;
  }

  BookDetail.fromJson(dynamic json) {
    _bookDetail =
        json['bookDetail'] != null ? json['bookDetail'].cast<String>() : [];
  }

  late final List<String> _bookDetail;

  List<String> get bookDetail => _bookDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bookDetail'] = _bookDetail;
    return map;
  }
}
