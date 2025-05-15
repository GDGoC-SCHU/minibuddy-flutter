import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

class NicknameInputScreen extends StatefulWidget {
  final bool isFromEdit;

  const NicknameInputScreen({super.key, this.isFromEdit = false});
  @override
  State<NicknameInputScreen> createState() => _NicknameInputScreenState();
}

class _NicknameInputScreenState extends State<NicknameInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String _nickname = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _nickname = value.trim();
    });
  }

  void _onSubmit() {
    if (_nickname.isEmpty) return;

    OnboardingState().nickname = _nickname; // 입력값 저장

    if (widget.isFromEdit) {
      Navigator.pop(context, _nickname);
    } else {
      context.push('/onboarding/birthday'); // 온보딩 진행
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.isFromEdit;

    return Stack(
      children: [
        // 전체 화면 배경 이미지
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),

        // Scaffold 위에 배경 이미지가 깔린 구조
        Scaffold(
          backgroundColor: Colors.transparent, // 배경 투명하게
          appBar: AppBar(
            backgroundColor: Colors.transparent, // AppBar도 투명
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 120.h),
                Text(
                  'Hi! What should\nwe call you?',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 180.h),
                TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hintText: 'Enter your nickname',
                    hintStyle:
                        TextStyle(color: Colors.grey[700], fontSize: 16.sp),
                    enabledBorder: OutlineInputBorder(
                      // 테두리 굵기
                      borderSide: BorderSide(
                        color: Colors.grey[700]!,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 테두리 굵기
                      borderSide: BorderSide(
                        color: Colors.grey[800]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _nickname.isEmpty ? null : _onSubmit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color.fromARGB(
                                159, 109, 109, 109)!; // 비활성화일 때 색상 지정
                          }
                          return const Color.fromARGB(
                              255, 55, 55, 55)!; // 활성화일 때
                        },
                      ),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                      )),
                    ),
                    child: Text(isEditing ? 'Save' : 'Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
