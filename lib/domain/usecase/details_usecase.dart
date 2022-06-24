import 'package:dartz/dartz.dart';
import 'package:udvanced_flutter/domain/model/models.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class StoreDetailsUseCase implements BaseUseCase<void, StoreDetails> {
  final Repository repository;

  StoreDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await repository.getStoreDetails();
  }
}