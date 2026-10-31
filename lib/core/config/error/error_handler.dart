import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'failures.dart';

/// Runs a data-source call and converts any thrown error into a [Failure].
///
/// Repositories wrap every Supabase call with this, so no feature needs its
/// own try/catch and no raw exception text ever reaches the UI.
Future<Either<Failure, T>> guardCall<T>(Future<T> Function() action) async {
  try {
    return Right<Failure, T>(await action());
  } on AuthException catch (e) {
    return Left<Failure, T>(AuthFailure(_authMessage(e.message)));
  } on PostgrestException catch (e) {
    return Left<Failure, T>(_postgrestFailure(e));
  } on FormatException {
    return Left<Failure, T>(
      const UnexpectedFailure('تعذر قراءة البيانات القادمة من الخادم'),
    );
  } catch (e) {
    if (_looksLikeNetworkError(e.toString())) {
      return Left<Failure, T>(const NetworkFailure());
    }
    return Left<Failure, T>(const UnexpectedFailure());
  }
}

bool _looksLikeNetworkError(String text) {
  return text.contains('SocketException') ||
      text.contains('ClientException') ||
      text.contains('Failed host lookup') ||
      text.contains('TimeoutException') ||
      text.contains('Network is unreachable') ||
      text.contains('Connection closed') ||
      text.contains('Connection refused') ||
      text.contains('Connection reset') ||
      text.contains('Connection failed');
}

String _authMessage(String raw) {
  final m = raw.toLowerCase();
  if (m.contains('invalid login credentials')) {
    return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  }
  if (m.contains('already registered') || m.contains('already been registered')) {
    return 'هذا البريد الإلكتروني مسجل مسبقًا';
  }
  if (m.contains('email not confirmed')) {
    return 'يرجى تأكيد بريدك الإلكتروني أولًا';
  }
  if (m.contains('password should be at least')) {
    return 'كلمة المرور قصيرة جدًا';
  }
  if (m.contains('rate limit') || m.contains('too many')) {
    return 'محاولات كثيرة، انتظر قليلًا ثم أعد المحاولة';
  }
  if (_looksLikeNetworkError(raw)) {
    return 'تعذر الاتصال بالإنترنت، تحقق من الشبكة';
  }
  return 'تعذر إكمال العملية، حاول مرة أخرى';
}

Failure _postgrestFailure(PostgrestException e) {
  switch (e.code) {
    case '23505': // unique_violation
      return const ValidationFailure('هذا العنصر موجود مسبقًا');
    case '23503': // foreign_key_violation
      return const ValidationFailure('العنصر المرتبط غير موجود');
    case '23514': // check_violation
      return const ValidationFailure('القيمة المدخلة غير مسموحة');
    case '42501': // insufficient_privilege (blocked by RLS)
      return const AuthFailure('ليست لديك صلاحية لتنفيذ هذا الإجراء');
    case 'PGRST116': // single() matched no rows
      return const NotFoundFailure();
    default:
      return const ServerFailure();
  }
}