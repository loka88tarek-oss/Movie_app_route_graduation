class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

class AuthException implements Exception {
  final String message;
  const AuthException({required this.message});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error occurred'});
}
