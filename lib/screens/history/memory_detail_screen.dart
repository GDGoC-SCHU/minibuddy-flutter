import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/models/history_models.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/utils/handle_request.dart';
import 'package:flutter/services.dart';

class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({super.key});

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  final _repository = HistoryRepository(HistoryApi(ApiClient.instance));
  List<MemoryHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent == true && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _fetchHistory() {
    setState(() => _isLoading = true);
    handleRequest<List<MemoryHistory>>(
      context: context,
      fetch: () => _repository.getMemoryHistory(),
      onSuccess: (data) {
        setState(() {
          _history = data.reversed.toList();
          _isLoading = false;
        });
      },
      retry: () {
        setState(() => _isLoading = false);
        _fetchHistory();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Memory History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            top: true,
            bottom: false,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                    itemCount: _history.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = _history[index];

                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEA),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x22000000),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Q + 날짜
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40.w,
                                    child: Text(
                                      'Q:',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    ////질문!!!!!!!!!!!!!!!!!--------------------------
                                    child: Text(
                                      item.question,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    ////날짜!!!!!!!!!!!!!!!!!--------------------------
                                    padding:
                                        EdgeInsets.only(left: 8.w), // 날짜 왼쪽 패딩
                                    child: Text(
                                      item.date,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Pretendard',
                                        color: const Color.fromARGB(
                                            255, 86, 86, 86),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),

                              // A:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40.w,
                                    child: Text(
                                      'A:',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    ////대답!!!!!!!!!!!!!!!!!--------------------------
                                    child: Text(
                                      item.answer,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // 이유는 왼쪽으로 정렬 유지 (공백 없이)
                              Text(
                                ////이유!!!!!!!!!!!!!!!!!--------------------------
                                item.mciReason,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
