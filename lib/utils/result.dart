//utilizar está clase para una forma mas limpia de manejo de resultados de un ApiService
sealed class Result<T> {
  String? get message => null;
}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  @override
  final String message;
  Failure(this.message);
}
