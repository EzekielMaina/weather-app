sealed class APIException implements Exception {
  APIException(this.message);
  final String message;

  dynamic getErrorMessage() {
    return message;
  }
}

class InvalidApiKeyException extends APIException {
  InvalidApiKeyException() : super('Invalid API key');
}

class NoQueryException extends APIException {
  NoQueryException() : super('Please enter a valid query');
}

class NoInternetConnectionException extends APIException {
  NoInternetConnectionException() : super('No Internet connection ');
}

class CityNotFoundException extends APIException {
  CityNotFoundException() : super('City not found');
}

class UnknownException extends APIException {
  UnknownException() : super('An Unknown error occurred');
}
