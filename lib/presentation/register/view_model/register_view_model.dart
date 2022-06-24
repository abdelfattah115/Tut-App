import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:udvanced_flutter/domain/usecase/register_usecase.dart';

import '../../../app/functions.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../common/freezed_data_class.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/string_manager.dart';
import '../../base/base_view_model.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isRegisteredInSuccessfullyStreamController = StreamController<bool>();

  var registerObject = RegisterObject("", "", "", "", "", "");
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  @override
  void start() {
    inputAllInputsValid.add(ContentState());
  }

  // ---> inputs
  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold((failure) {
      // left -> failure
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (data) {
      // right -> data (success)
      //content
      inputState.add(ContentState());
      // navigate to main screen
      isRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      // update Register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset userName value in Register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      // update Register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset CountryCode value in Register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // update Register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset Email value in Register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      // update Register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset Mobile Number value in Register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // update Register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset Password value in Register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      // update Register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset Password value in Register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

  // ---> outputs
  @override
  Stream<bool> get outputsUserName => _userNameStreamController.stream
      .map((username) => _isUserNameValid(username));

  @override
  Stream<String?> get outputsErrorUserName => outputsUserName
      .map((isUserName) => isUserName ? null : AppString.userNameInvalid.tr());

  @override
  Stream<bool> get outputsEmail =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputsErrorEmail =>
      outputsEmail.map((isEmail) => isEmail ? null : AppString.invalidEmail.tr());

  @override
  Stream<bool> get outputsMobileNumber => _mobileNumberStreamController.stream
      .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputsErrorMobileNumber =>
      outputsMobileNumber.map((isMobileNumber) =>
          isMobileNumber ? null : AppString.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outputsPassword => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputsErrorPassword => outputsPassword
      .map((isPassword) => isPassword ? null : AppString.passwordInvalid.tr());

  @override
  Stream<File> get outputsProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputsAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  // ---> private function
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.profilePicture.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty &&
        registerObject.userName.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }

  @override
  void dispose() {
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _areAllInputsValidStreamController.close();
    isRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }
}

abstract class RegisterViewModelInputs {
  Sink get inputUserName;

  Sink get inputMobileNumber;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePicture;

  Sink get inputAllInputsValid;

  register();

  setUserName(String userName);

  setMobileNumber(String mobileNumber);

  setEmail(String email);

  setPassword(String password);

  setCountryCode(String countryCode);

  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputsUserName;

  Stream<String?> get outputsErrorUserName;

  Stream<bool> get outputsMobileNumber;

  Stream<String?> get outputsErrorMobileNumber;

  Stream<bool> get outputsEmail;

  Stream<String?> get outputsErrorEmail;

  Stream<bool> get outputsPassword;

  Stream<String?> get outputsErrorPassword;

  Stream<File> get outputsProfilePicture;

  Stream<bool> get outputsAllInputsValid;
}
