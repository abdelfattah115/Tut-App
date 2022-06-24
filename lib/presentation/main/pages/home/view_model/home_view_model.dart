import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'package:udvanced_flutter/domain/model/models.dart';

import '../../../../../domain/usecase/home_usecase.dart';
import '../../../../base/base_view_model.dart';
import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewObject {
  List<BannerAd> banners;
  List<Service> services;
  List<Store> stores;

  HomeViewObject(this.banners, this.services, this.stores);
}

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final StreamController _homeViewObjectStreamController =
      BehaviorSubject<HomeViewObject>();
  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // ---> inputs
  @override
  void start() {
    _getHomeData();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void)).fold((failure) {
      // left -> failure
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (homeObject) {
      // right -> data (success)
      //content
      inputState.add(ContentState());
      inputHomeView.add(HomeViewObject(homeObject.data.banners,
          homeObject.data.services, homeObject.data.stores));
      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _homeViewObjectStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeView => _homeViewObjectStreamController.sink;

  // ---> outputs
  @override
  Stream<HomeViewObject> get outputHomeView =>
      _homeViewObjectStreamController.stream.map((homeView) => homeView);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeView;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeView;
}
