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
      Navigator.pop(context, _selected); // 마이페이지에서 복귀
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
    final theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.grey[800]!,
        onPrimary: Colors.white,
        onSurface: Colors.grey[800]!,
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Your Interests'),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What topics are you into? (${_selected.length}/5)',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _keywords.map((keyword) {
                      final selected = _selected.contains(keyword);
                      return GestureDetector(
                        onTap: () => _toggle(keyword),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? theme.colorScheme.primary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
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
                              fontSize: 14.sp,
                              color: selected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: Text(
                    widget.isFromEdit
                        ? 'Save'
                        : _selected.isEmpty
                            ? 'Skip'
                            : 'Continue (${_selected.length}/5)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
