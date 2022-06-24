import 'dart:async';
import 'dart:ffi';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/models.dart';
import '../../../domain/usecase/details_usecase.dart';
import '../../base/base_view_model.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';


class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  final _storeDetailsStreamController = BehaviorSubject<StoreDetails>();

  @override
  void start() {
    _getStoreDetails();
  }

  _getStoreDetails() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _storeDetailsUseCase.execute(Void)).fold((failure) {
      // left -> failure
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (storeDetail) {
      // right -> data (success)
      //content
      inputState.add(ContentState());
      inputStoreDetails.add(storeDetail);
      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((storeDetails) => storeDetails);
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetails;
}
