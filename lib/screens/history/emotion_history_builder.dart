import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/models/history_models.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/utils/handle_request.dart';

class EmotionHistoryBuilder extends StatefulWidget {
  final String type; // "ANXIETY", "DEPRESSION", "STRESS"

  const EmotionHistoryBuilder({super.key, required this.type});

  @override
  State<EmotionHistoryBuilder> createState() => _EmotionHistoryBuilderState();
}

class _EmotionHistoryBuilderState extends State<EmotionHistoryBuilder> {
  final _repository = HistoryRepository(HistoryApi(ApiClient.instance));
  List<EmotionHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    handleRequest<List<EmotionHistory>>(
      context: context,
      fetch: () => _repository.getEmotionHistory(widget.type),
      onSuccess: (data) {
        setState(() {
          _history = data;
          _isLoading = false; // ✅ 로딩 종료
        });
      },
      onError: (_) {
        setState(() {
          _isLoading = false; // ✅ 실패해도 로딩 종료
        });
      },
      retry: _fetchHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // ✅ 로딩 중 표시
    }

    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🕊️', style: TextStyle(fontSize: 70.sp)),
            SizedBox(height: 4.h),
            Text(
              "No records yet\nand that's totally fine.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF555555),
                height: 1.5,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      top: true,
      bottom: false,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
        itemCount: _history.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final item = _history[index];

          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.message,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Pretendard',
                      color: const Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
