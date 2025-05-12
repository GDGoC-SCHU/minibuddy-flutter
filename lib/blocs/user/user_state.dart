import 'package:minibuddy/models/user_status_model.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserStatusModel status;
  final List<EmotionFlowModel> flow;
  final EmotionDistributionModel distribution;

  UserLoaded(
      {required this.status, required this.flow, required this.distribution});
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}
