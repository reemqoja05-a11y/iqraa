import 'package:equatable/equatable.dart';

/// Base class for every error that reaches the domain/presentation layers.
/// [message] is already user-friendly (Arabic) and safe to display.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم، حاول مرة أخرى']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تعذر الاتصال بالإنترنت، تحقق من الشبكة']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'تعذر إكمال العملية، حاول مرة أخرى']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر المطلوب غير موجود']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'البيانات المدخلة غير صحيحة']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع']);
}