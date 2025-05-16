import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/blocs/history/history_bloc.dart';
import 'package:minibuddy/blocs/history/history_event.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/screens/history/emotion_history_builder.dart';
import 'package:minibuddy/utils/api_client.dart';

class DepressionDetailScreen extends StatelessWidget {
  const DepressionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(
        HistoryRepository(HistoryApi(ApiClient.instance)),
      )..add(FetchEmotionHistory("DEPRESSION")),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Depression History',
            style: TextStyle(fontSize: 20.sp, color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/home_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const EmotionHistoryBuilder(type: "DEPRESSION"),
          ],
        ),
      ),
    );
  }
}
