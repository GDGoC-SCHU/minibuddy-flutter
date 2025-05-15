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
    OnboardingState().birthdate = formatted;

    if (widget.isFromEdit) {
      Navigator.pop(context, _selectedDate);
    } else {
      context.push('/onboarding/keyword');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.isFromEdit;
    final String dateText = _selectedDate != null
        ? DateFormat('yyyy.MM.dd').format(_selectedDate!)
        : 'Select your birthday';

    return Stack(
      children: [
        // ✅ 전체 배경 이미지
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),

        // ✅ 투명 Scaffold 위에 내용 구성
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 120.h),
                Text(
                  'When is your\nbirthday?',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 180.h),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[800]!,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        color: _selectedDate != null
                            ? Colors.black
                            : Colors.grey[800],
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color.fromARGB(
                                159, 109, 109, 109); // 비활성화 색상
                          }
                          return const Color.fromARGB(
                              255, 55, 55, 55); // 활성화 색상
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
