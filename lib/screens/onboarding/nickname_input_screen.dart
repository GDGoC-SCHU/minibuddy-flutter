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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Nickname'),
        // 🙌 🙌 🙌 여기 false로 변경할 것!!
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What should we call you?',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.h),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Enter your nickname',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _nickname.isEmpty ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _nickname.isEmpty ? Colors.grey[300] : Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                child: Text(isEditing ? 'Save' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
