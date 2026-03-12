import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class SyncRepository {
  Future<Either<Failure, Unit>> syncAll();
}
