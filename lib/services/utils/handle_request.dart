import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:minibuddy/screens/common/error_page.dart';
import 'package:minibuddy/services/utils/error_type.dart';

Future<void> handleRequest<T>({
  required BuildContext context,
  required Future<T> Function() fetch,
  required void Function(T data) onSuccess,
  required VoidCallback retry,
  Widget? backScreen,
}) async {
  try {
    final data = await fetch();
    if (context.mounted) {
      onSuccess(data);
    }
  } on DioException catch (e) {
    if (context.mounted) {
      final errorType = _mapErrorTypeFromDio(e);
      _goToError(context, errorType, retry, backScreen);
    }
  } catch (_) {
    if (context.mounted) {
      _goToError(context, ErrorType.unknown, retry, backScreen);
    }
  }
}

void _goToError(
  BuildContext context,
  ErrorType errorType,
  VoidCallback retry,
  Widget? backScreen,
) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => ErrorPage(
        errorType: errorType,
        onRetry: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) => retry());
        },
        backScreen: backScreen,
      ),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

ErrorType _mapErrorTypeFromDio(DioException e) {
  final statusCode = e.response?.statusCode;

  if (statusCode == 400) return ErrorType.badRequest;
  if (statusCode == 500) return ErrorType.serverError;

  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown) {
    return ErrorType.connectionError;
  }

  return ErrorType.unknown;
}
