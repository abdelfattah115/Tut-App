import 'package:dartz/dartz.dart';
import 'package:udvanced_flutter/data/network/failure.dart';
import 'package:udvanced_flutter/domain/model/models.dart';
import 'package:udvanced_flutter/domain/repository/repository.dart';
import 'package:udvanced_flutter/domain/usecase/base_usecase.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
