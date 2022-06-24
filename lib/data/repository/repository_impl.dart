import 'package:dartz/dartz.dart';
import 'package:udvanced_flutter/data/data_source/local_data_source.dart';

import '../network/error_handler.dart';
import '../data_source/remote_data_source.dart';
import '../mapper/mapper.dart';
import '../network/failure.dart';
import '../network/requests.dart';
import '../../domain/model/models.dart';
import '../../domain/repository/repository.dart';
import '../network/network_info.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo, this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe call API

      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternetConnection.SUCCESS) {
          // return success
          // return Either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure -- return business error
          // return either left
          return Left(Failure(ApiInternetConnection.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternetConnection.SUCCESS) {
          // return success
          // return right
          return Right(response.toDomain());
        } else {
          // failure -- return business error
          // return  left
          return Left(Failure(ApiInternetConnection.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    }else{
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe call API

      try {
        final response = await _remoteDataSource.register(registerRequest);

        if (response.status == ApiInternetConnection.SUCCESS) {
          // return success
          // return Either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure -- return business error
          // return either left
          return Left(Failure(ApiInternetConnection.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async{
    try{
      // get response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    }catch (cacheError){
      // cache is not existing or cache is not valid

      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet, its safe call API

        try {
          final response = await _remoteDataSource.getHomeData();

          if (response.status == ApiInternetConnection.SUCCESS) {
            // return success
            // return Either right
            // return data

            // save response in cache (local data source)
            _localDataSource.saveDataToCache(response);
            return Right(response.toDomain());
          } else {
            // failure -- return business error
            // return either left
            return Left(Failure(ApiInternetConnection.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }


  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async{
    try{
      // get response from cache
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    }catch (cacheError){
      // cache is not existing or cache is not valid

      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet, its safe call API

        try {
          final response = await _remoteDataSource.getStoreDetails();

          if (response.status == ApiInternetConnection.SUCCESS) {
            // return success
            // return Either right
            // return data

            // save response in cache (local data source)
            _localDataSource.saveStoreDetailsToCache(response);
            return Right(response.toDomain());
          } else {
            // failure -- return business error
            // return either left
            return Left(Failure(ApiInternetConnection.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
