import 'package:flutter/material.dart';
import 'package:minibuddy/services/utils/error_type.dart';

class ErrorPage extends StatelessWidget {
  final ErrorType errorType;
  final VoidCallback onRetry;
  final Widget? backScreen;

  const ErrorPage({
    super.key,
    required this.errorType,
    required this.onRetry,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(errorType);
    final title = _titleFor(errorType);
    final message = _messageFor(errorType);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontFamily: 'Pretendard',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(ErrorType type) {
    switch (type) {
      case ErrorType.serverError:
        return Icons.cloud_off;
      case ErrorType.connectionError:
        return Icons.wifi_off;
      case ErrorType.unknown:
      default:
        return Icons.error_outline;
    }
  }

  String _titleFor(ErrorType type) {
    switch (type) {
      case ErrorType.serverError:
        return "Server Error";
      case ErrorType.connectionError:
        return "Network Error";
      case ErrorType.unknown:
      default:
        return "Unexpected Error";
    }
  }

  String _messageFor(ErrorType type) {
    switch (type) {
      case ErrorType.serverError:
        return "We're having trouble connecting to the server.\nPlease try again later.";
      case ErrorType.connectionError:
        return "It looks like you're offline.\nCheck your internet connection and try again.";
      case ErrorType.unknown:
      default:
        return "An unexpected error occurred.\nPlease try again.";
    }
  }
}
