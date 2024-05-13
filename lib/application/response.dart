class Pagination {
  final bool hasNextPage;
  final int totalData;

  Pagination({
    required this.hasNextPage,
    required this.totalData,
  });

  @override
  String toString() {
    return 'Pagination{hasNextPage: $hasNextPage, totalData: $totalData}';
  }
}

class ResponseEntity<T> {
  final bool isError;
  final T? data;
  final bool isConnectionTimeout;
  final Pagination? pagination;
  final bool isSocket;
  final String? errorMessage;
  final Map<String, dynamic> fieldErrors;
  final int statusCode;


  ResponseEntity(
      {required this.isError,
      this.pagination,
      this.fieldErrors = const {},
      required this.data,
      required this.errorMessage,
        this.statusCode = 200,
      this.isConnectionTimeout = false,
      this.isSocket = false});

  factory ResponseEntity.Socket() {
    return ResponseEntity(
        isError: true,
        data: null,
        isSocket: true,
        errorMessage: 'Please check your internet connection');
  }

  factory ResponseEntity.Timeout() {
    return ResponseEntity(
        isError: true,
        data: null,
        errorMessage:
            "Connection timeout, Please check your network and try again",
        isConnectionTimeout: true);
  }

  factory ResponseEntity.Error(dynamic errors,
      {Map<String, dynamic> fieldErrors = const {}, int statusCode = 400,}) {
    return ResponseEntity(
        isError: true,
        fieldErrors: fieldErrors,
        data: null,
        errorMessage: errors);
  }

  factory ResponseEntity.Data(T data, {Pagination? pagination}) {
    return ResponseEntity(
        isError: false, data: data, errorMessage: null, pagination: pagination);
  }

  @override
  String toString() {
    return 'ResponseEntity{isError: $isError, data: $data, isConnectionTimeout: $isConnectionTimeout, pagination: $pagination, isSocket: $isSocket, errorMessage: $errorMessage, fieldErrors: $fieldErrors, statusCode: $statusCode}';
  }
}
