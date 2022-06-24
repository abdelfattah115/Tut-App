import 'package:dartz/dartz.dart';
import 'package:udvanced_flutter/data/network/failure.dart';
import 'package:udvanced_flutter/domain/repository/repository.dart';
import 'package:udvanced_flutter/domain/usecase/base_usecase.dart';

class ForgotPasswordUseCase implements BaseUseCase{
  final Repository _repository;
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, dynamic>> execute(input) async{
     return await _repository.forgotPassword(input);
  }
}