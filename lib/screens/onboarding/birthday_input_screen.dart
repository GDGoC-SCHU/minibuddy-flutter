import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

class BirthdayInputScreen extends StatefulWidget {
  final bool isFromEdit;
  const BirthdayInputScreen({super.key, this.isFromEdit = false});

  @override
  State<BirthdayInputScreen> createState() => _BirthdayInputScreenState();
}

class _BirthdayInputScreenState extends State<BirthdayInputScreen> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.grey[800]),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onSubmit() {
    if (_selectedDate == null) return;

    final formatted = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    OnboardingState().birthdate = formatted; // 생일을 문자열로 저장

    if (widget.isFromEdit) {
      Navigator.pop(context, _selectedDate); // 마이페이지로 복귀
    } else {
      context.push('/onboarding/keyword'); // 다음 온보딩 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dateText = _selectedDate != null
        ? DateFormat('yyyy.MM.dd').format(_selectedDate!)
        : 'Select your birthday';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Birthday'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'When is your birthday?',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: _selectedDate != null
                        ? Colors.black
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _selectedDate == null ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedDate == null ? Colors.grey[300] : Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                child: Text(widget.isFromEdit ? 'Save' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
