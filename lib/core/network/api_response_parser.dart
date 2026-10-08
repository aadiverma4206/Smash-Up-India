class ApiResponseParser {
  static T parse<T>(dynamic response, T Function(dynamic json) parser) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        return parser(response['data']);
      }
      return parser(response);
    }
    return parser(response);
  }
}
