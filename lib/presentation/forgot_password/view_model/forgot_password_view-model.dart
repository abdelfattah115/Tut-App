import 'dart:async';

import 'package:udvanced_flutter/app/functions.dart';
import 'package:udvanced_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:udvanced_flutter/presentation/base/base_view_model.dart';
import 'package:udvanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:udvanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _isInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = '';

  @override
  void dispose() {
    _userNameStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputEmail => _userNameStreamController.sink;

  @override
  Sink get inputIsAllValid => _isInputValidStreamController.sink;

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  // output
  @override
  Stream<bool> get outputEmail => _userNameStreamController.stream
      .map((userName) => _isUsernameValid(userName));

  bool _isUsernameValid(String userName) {
    return userName.isNotEmpty;
  }

  void _validate() {
    inputIsAllValid.add(null);
  }

  @override
  Stream<bool> get outputIsAllValid =>
      _isInputValidStreamController.stream.map((isAllInputValid) => _isAllInputsValid());

  _isAllInputsValid() {
    return isEmailValid(email);
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);

  Sink get inputEmail;

  Sink get inputIsAllValid;

  forgotPassword();
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputEmail;

  Stream<bool> get outputIsAllValid;
}
