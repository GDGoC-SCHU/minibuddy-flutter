import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/data/profile/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError('불러오기 실패'));
      }
    });

    on<UpdateProfile>((event, emit) async {
      try {
        await repository.updateProfile(
          name: event.name,
          birthdate: event.birthdate,
          keywords: event.keywords,
        );
        final updated = await repository.getProfile();
        emit(ProfileLoaded(updated));
      } catch (e) {
        emit(ProfileError('수정 실패'));
      }
    });
  }
}
