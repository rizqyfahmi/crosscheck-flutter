import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/repositories/main_repository_impl.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_source.dart';
import 'package:crosscheck/features/walkthrough/data/repositories/walkthrough_repository_impl.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Seems like Dagger, it prepares all depedency we need
final locator = GetIt.instance;
Future<void> init() async  {
  locator.registerFactory(() => AuthenticationBloc());
  locator.registerFactory(() => RegistrationBloc(registrationUsecase: locator()));
  locator.registerFactory(() => LoginBloc(loginUsecase: locator()));
  locator.registerFactory(() => WalkthroughBloc(setIsSkipUsecase: locator(), getIsSkipUsecase: locator()));
  locator.registerFactory(() => MainBloc(getActiveBottomNavigationUsecase: locator(), setActiveBottomNavigationUsecase: locator()));

  locator.registerLazySingleton(() => RegistrationUsecase(repository: locator()));
  locator.registerLazySingleton(() => LoginUsecase(repository: locator()));
  locator.registerLazySingleton(() => SetIsSkipUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetIsSkipUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetActiveBottomNavigationUsecase(repository: locator()));
  locator.registerLazySingleton(() => SetActiveBottomNavigationUsecase(repository: locator()));
  locator.registerLazySingleton<WalkthroughRepository>(() => WalkthroughRepositoryImpl(walkthroughLocalDataSource: locator()));
  locator.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(
    remote: locator(), local: locator(), networkInfo: locator()
  ));
  locator.registerLazySingleton<MainRepository>(() => MainRepositoryImpl(mainLocalDataSource: locator()));
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<WalkthroughLocalDataSource>(() => WalkthroughLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<MainLocalDataSource>(() => MainLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: locator()));
  
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => InternetConnectionChecker());
}