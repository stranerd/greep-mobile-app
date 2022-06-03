/// @author Ibekason Alexander
///
/// Model for paginations

class PageRequest {
  final int size;
  final int page;

  PageRequest({this.size = 15, this.page = 1});

  @override
  String toString() {
    return 'PageRequest{size: $size, page: $page,}';
  }

  factory PageRequest.fromMap(Map<String, dynamic> map) {
    return new PageRequest(
      size: map['size'] as int,
      page: map['page'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'size': this.size,
      'page': this.page,
    } as Map<String, dynamic>;
  }
}
