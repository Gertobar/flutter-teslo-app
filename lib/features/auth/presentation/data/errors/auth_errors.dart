class ConnectionTimeout implements Exception{}
class InvalidToken implements Exception {}
class WrongCredentials implements Exception {}

class CustomError implements Exception {
  final String message;
  //final bool loggedRequired;

  CustomError(this.message);
  //CustomError(this.messaje, [this.loggedRequired = false]);
}