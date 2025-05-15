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

    OnboardingState().nickname = _nickname;

    if (widget.isFromEdit) {
      Navigator.pop(context, _nickname);
    } else {
      context.push('/onboarding/birthday');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.isFromEdit;

    return WillPopScope(
      onWillPop: () async => widget.isFromEdit, // 뒤로가기 허용 여부 제어
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // 본문 Scaffold
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: widget.isFromEdit, // 뒤로가기 버튼 조건부 표시
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
                      hintStyle: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[800]!,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _nickname.isEmpty ? null : _onSubmit,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color.fromARGB(159, 109, 109, 109);
                            }
                            return const Color.fromARGB(255, 55, 55, 55);
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
      ),
    );
  }
}
