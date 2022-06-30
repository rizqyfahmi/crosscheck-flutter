import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_model.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_bloc_test.mocks.dart';

@GenerateMocks([
  GetProfileUsecase
])
void main() {
  late MockGetProfileUsecase mockGetProfileUsecase;
  late ProfileBloc profileBloc;
  
  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
    profileBloc = ProfileBloc(getProfileUsecase: mockGetProfileUsecase);
  });

  test('Should get ProfileInit at first time', () {
    expect(profileBloc.state, const ProfileInit());
  });

  test('Should get profile properly', () {
    final entity = ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => Right(entity));

    profileBloc.add(ProfileGetData());
    
    expect(profileBloc.stream, emitsInOrder([
      const ProfileLoading(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileLoaded(model: ProfileModel(fullname: "fulan", email: "fulan@email.com", formattedDob: "11-01-1991", address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60"))
    ]));
  });

  test('Should returns ProfileGeneralError when get profile returns ServerFailure', () {
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    profileBloc.add(ProfileGetData());

    expect(profileBloc.stream, emitsInOrder([
      const ProfileLoading(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileGeneralError(message: Failure.generalError, model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=."))
    ]));

  });

  test('Should returns ProfileNoGeneralError when user hide general error after ServerFailure', () {
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    profileBloc.add(ProfileGetData());
    profileBloc.add(ProfileResetGeneralError());

    expect(profileBloc.stream, emitsInOrder([
      const ProfileLoading(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileGeneralError(message: Failure.generalError, model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileNoGeneralError(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=."))
    ]));

  });

  test('Should returns ProfileGeneralError when get profile returns CacheFailure', () {
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    profileBloc.add(ProfileGetData());

    expect(profileBloc.stream, emitsInOrder([
      const ProfileLoading(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileGeneralError(message: Failure.cacheError, model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=."))
    ]));

  });

  test('Should returns ProfileNoGeneralError when user hide general error after CacheFailure', () {
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => const Left(CacheFailure(message: Failure.cacheError)));

    profileBloc.add(ProfileGetData());
    profileBloc.add(ProfileResetGeneralError());

    expect(profileBloc.stream, emitsInOrder([
      const ProfileLoading(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileGeneralError(message: Failure.cacheError, model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=.")),
      const ProfileNoGeneralError(model: ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=."))
    ]));

  });
}