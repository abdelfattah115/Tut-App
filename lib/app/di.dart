import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udvanced_flutter/app/app_prefs.dart';
import 'package:udvanced_flutter/data/data_source/local_data_source.dart';
import 'package:udvanced_flutter/data/data_source/remote_data_source.dart';
import 'package:udvanced_flutter/data/network/app_api.dart';
import 'package:udvanced_flutter/data/network/dio_factory.dart';
import 'package:udvanced_flutter/data/network/network_info.dart';
import 'package:udvanced_flutter/data/repository/repository_impl.dart';
import 'package:udvanced_flutter/domain/repository/repository.dart';
import 'package:udvanced_flutter/domain/usecase/details_usecase.dart';
import 'package:udvanced_flutter/domain/usecase/home_usecase.dart';
import 'package:udvanced_flutter/domain/usecase/login_usecase.dart';
import 'package:udvanced_flutter/domain/usecase/register_usecase.dart';
import 'package:udvanced_flutter/presentation/login/view_model/login_view_model.dart';
import 'package:udvanced_flutter/presentation/main/pages/home/view_model/home_view_model.dart';
import 'package:udvanced_flutter/presentation/register/view_model/register_view_model.dart';

import '../domain/usecase/forgot_password_usecase.dart';
import '../presentation/forgot_password/view_model/forgot_password_view-model.dart';
import '../presentation/store_details/view_model/store_details_view-model.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where you put all generic dependencies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance.registerLazySingleton<AppPreferences>(
    () => AppPreferences(instance()),
  );

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  // app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}


initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(() => StoreDetailsUseCase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(() => StoreDetailsViewModel(instance()));
  }
}
