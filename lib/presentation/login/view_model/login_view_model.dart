import 'dart:async';

import '../../../domain/usecase/login_usecase.dart';
import '../../base/base_view_model.dart';
import '../../common/freezed_data_class.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInput, LoginViewModelOutput {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllValidInputsStreamController =
      StreamController<void>.broadcast();

  StreamController isLoggedInSuccessfullyStreamController = StreamController<bool>();

  var loginObject = LoginObject("", "");
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllValidInputsStreamController.close();
    isLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // view model should tell view please show content state.
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((failure) {
      // left -> failure
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (data) {
      // right -> data (success)
      //content
      inputState.add(ContentState());
      // navigate to main screen
      isLoggedInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inAreAllInputsValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inAreAllInputsValid.add(null);
  }

  @override
  Sink get inAreAllInputsValid => _areAllValidInputsStreamController.sink;

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isUserNameValid(loginObject.userName) &&
        _isPasswordValid(loginObject.password);
  }

  // outputs
  @override
  Stream<bool> get outputPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllValidInputsStreamController.stream
          .map((_) => _areAllInputsValid());
}

abstract class LoginViewModelInput {
  setUserName(String userName);

  setPassword(String password);

  login();

  Sink get inputUserName;

  Sink get inputPassword;

  Sink get inAreAllInputsValid;
}

abstract class LoginViewModelOutput {
  Stream<bool> get outputUserNameValid;

  Stream<bool> get outputPasswordValid;

  Stream<bool> get outAreAllInputsValid;
}
