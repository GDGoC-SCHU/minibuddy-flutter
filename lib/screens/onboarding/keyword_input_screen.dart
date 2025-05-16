import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';
import 'package:minibuddy/services/onboarding/onboarding_repository.dart';
import 'package:minibuddy/utils/handle_request.dart';

class KeywordInputScreen extends StatefulWidget {
  final bool isFromEdit;

  const KeywordInputScreen({super.key, this.isFromEdit = false});

  @override
  State<KeywordInputScreen> createState() => _KeywordInputScreenState();
}

class _KeywordInputScreenState extends State<KeywordInputScreen> {
  final List<String> _keywords = [
    'Travel',
    'Games',
    'Music',
    'Sleep',
    'Reading',
    'Fitness',
    'Food',
    'K-Drama',
    'MBTI',
    'Talking',
    'Pets',
    'Coffee',
    'Tech',
    'Movies',
    'Nature',
    'Shopping',
    'Volunteering',
  ];

  final List<String> _selected = [];

  void _toggle(String keyword) {
    setState(() {
      if (_selected.contains(keyword)) {
        _selected.remove(keyword);
      } else if (_selected.length < 5) {
        _selected.add(keyword);
      }
    });
  }

  void _onSubmit() async {
    OnboardingState().keywords = _selected;

    if (widget.isFromEdit) {
      Navigator.pop(context, _selected);
    } else {
      await handleRequest(
        context: context,
        fetch: () => OnboardingRepository().submitSignup(),
        onSuccess: (_) => context.go('/onboarding/welcome'),
        retry: _onSubmit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.isFromEdit;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true, // 배경 이미지가 AppBar 뒤로도 보이도록
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'What topics are you into?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontFamily: 'Pretendard',
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    '(${_selected.length}/5)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _keywords.map((keyword) {
                          final selected = _selected.contains(keyword);
                          return GestureDetector(
                            onTap: () => _toggle(keyword),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.grey[800]
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                keyword,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (states) => Colors.grey[800]!,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        )),
                      ),
                      child: Text(
                        isEditing
                            ? 'Save'
                            : _selected.isEmpty
                                ? 'Skip'
                                : 'Continue (${_selected.length}/5)',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
