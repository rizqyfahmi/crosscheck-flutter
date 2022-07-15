import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:crosscheck/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:crosscheck/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/repositories/main_repository_impl.dart';
import 'package:crosscheck/features/main/domain/repositories/main_repository.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:crosscheck/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/task/data/datasource/task_local_data_source.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/task_model.dart';
import 'package:crosscheck/features/task/data/repositories/task_repository_impl.dart';
import 'package:crosscheck/features/task/domain/repositories/task_respository.dart';
import 'package:crosscheck/features/task/domain/usecases/get_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_more_history_usecase.dart';
import 'package:crosscheck/features/task/domain/usecases/get_refresh_history_usecase.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_source.dart';
import 'package:crosscheck/features/walkthrough/data/repositories/walkthrough_repository_impl.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
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
  locator.registerFactory(() => DashboardBloc(getDashboardUsecase: locator()));
  locator.registerFactory(() => SettingsBloc(setThemeUsecase: locator(), getThemeUsecase: locator()));
  locator.registerFactory(() => ProfileBloc(getProfileUsecase: locator()));
  locator.registerFactory(() => TaskBloc(getHistoryUsecase: locator(), getMoreHistoryUsecase: locator(), getRefreshHistoryUsecase: locator()));

  locator.registerLazySingleton(() => RegistrationUsecase(repository: locator()));
  locator.registerLazySingleton(() => LoginUsecase(repository: locator()));
  locator.registerLazySingleton(() => SetIsSkipUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetIsSkipUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetActiveBottomNavigationUsecase(repository: locator()));
  locator.registerLazySingleton(() => SetActiveBottomNavigationUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetDashboardUsecase(repository: locator(), authenticationRepository: locator(), profileRepository: locator()));
  locator.registerLazySingleton(() => SetThemeUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetThemeUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetProfileUsecase(repository: locator(), authenticationRepository: locator()));
  locator.registerLazySingleton(() => GetHistoryUsecase(repository: locator(), authenticationRepository: locator()));
  locator.registerLazySingleton(() => GetMoreHistoryUsecase(repository: locator(), authenticationRepository: locator()));
  locator.registerLazySingleton(() => GetRefreshHistoryUsecase(repository: locator(), authenticationRepository: locator()));
  locator.registerLazySingleton<WalkthroughRepository>(() => WalkthroughRepositoryImpl(walkthroughLocalDataSource: locator()));
  locator.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(remote: locator(), local: locator(), networkInfo: locator()));
  locator.registerLazySingleton<MainRepository>(() => MainRepositoryImpl(mainLocalDataSource: locator()));
  locator.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remote: locator(), networkInfo: locator()));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(settingsLocalDataSource: locator()));
  locator.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remote: locator(), local: locator(), networkInfo: locator()));
  locator.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(remote: locator(), local: locator(), networkInfo: locator()));

  locator.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<WalkthroughLocalDataSource>(() => WalkthroughLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<MainLocalDataSource>(() => MainLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDdataSourceImpl(box: locator()));
  locator.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(taskBox: locator(), countedDailyTaskBox: locator()));

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: locator()));
  
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  
  final Box<ProfileModel> boxProfileModel = await Hive.openBox("profile");
  locator.registerLazySingleton<Box<ProfileModel>>(() => boxProfileModel);
  
  final Box<TaskModel> boxTaskModel = await Hive.openBox("Task");
  locator.registerLazySingleton<Box<TaskModel>>(() => boxTaskModel);

  final Box<TaskModel> boxCountedTaskByMonthModel = await Hive.openBox("CountedTaskByMonth");
  locator.registerLazySingleton<Box<TaskModel>>(() => boxCountedTaskByMonthModel);
  
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => InternetConnectionChecker());
}