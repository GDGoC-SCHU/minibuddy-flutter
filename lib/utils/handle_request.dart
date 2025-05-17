import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:minibuddy/screens/common/error_page.dart';
import 'package:minibuddy/utils/error_type.dart';
import 'package:minibuddy/screens/common/loading_page.dart';

Future<void> handleRequest<T>({
  required BuildContext context,
  required Future<T> Function() fetch,
  required void Function(T data) onSuccess,
  required VoidCallback retry,
  Widget? backScreen,
  void Function(Object error)? onError,
}) async {
  final stopwatch = Stopwatch()..start();
  bool showLoading = false;

  final delayed = Future.delayed(const Duration(milliseconds: 300));

  try {
    final fetchFuture = fetch();
    final data = await Future.any([
      fetchFuture,
      delayed,
    ]);

    final fetchResult = await fetchFuture;
    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds >= 300 && context.mounted) {
      showLoading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoadingScreen(),
      );
    }

    if (context.mounted) {
      if (showLoading) Navigator.of(context).pop();
      onSuccess(fetchResult);
    }
  } on DioException catch (e) {
    stopwatch.stop();
    if (context.mounted) {
      if (showLoading) Navigator.of(context).pop();
      if (onError != null) {
        onError(e); // 사용자 정의 에러 처리
      } else {
        final errorType = _mapErrorTypeFromDio(e);
        _goToError(context, errorType, retry, backScreen);
      }
    }
  } catch (e, stackTrace) {
    stopwatch.stop();
    if (context.mounted) {
      if (showLoading) Navigator.of(context).pop();
      debugPrint('❌ Unknown error: $e');
      debugPrint('📍 Stacktrace: $stackTrace');

      if (onError != null) {
        onError(e); // 사용자 정의 에러 처리
      } else {
        _goToError(context, ErrorType.unknown, retry, backScreen);
      }
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
