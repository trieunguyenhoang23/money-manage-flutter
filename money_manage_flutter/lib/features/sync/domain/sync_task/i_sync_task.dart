import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../data/model/sync_batch_progress.dart';

abstract class ISyncTask {
  SyncType get type;

  Stream<SyncBatchProgress> execute();

  BehaviorSubject<SyncBatchProgress> get controller;

  void reset();
}