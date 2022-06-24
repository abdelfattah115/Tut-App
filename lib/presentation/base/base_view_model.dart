import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:udvanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

abstract class BaseViewModel implements BaseViewModelInputs , BaseViewModelOutputs{
  // share variables and functions that will be used through any view model
  final StreamController _inputStreamController = BehaviorSubject<FlowState>();

  @override
  void dispose() {
    _inputStreamController.close();
  }

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState => _inputStreamController.stream.map((flowState) => flowState);
}

abstract class BaseViewModelInputs{
  void start();
  void dispose();

  Sink get inputState;
}

abstract class BaseViewModelOutputs{
  Stream<FlowState> get outputState;
}