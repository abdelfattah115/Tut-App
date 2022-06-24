import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udvanced_flutter/app/di.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../view_model/forgot_password_view-model.dart';
import '../../resources/color_manager.dart';

import '../../resources/assets_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordViewModel _viewModel =
      instance<ForgotPasswordViewModel>();

  bind() {
    _viewModel.start();
    _emailTextEditingController
        .addListener(() => _viewModel.setEmail(_emailTextEditingController.text));
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapShot){
          return snapShot.data?.getScreenWidget(context, _getContentWidget(), (){
            _viewModel.forgotPassword();
          }) ?? _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset(ImageAssets.splashLogo),
              ),
              const SizedBox(
                height: AppSize.s60,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputEmail,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: AppString.emailHint.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppString.invalidEmail.tr(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSize.s60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSize.s40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(AppString.resetPassword.tr()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p10,
                  left: AppPadding.p28,
                  right: AppPadding.p20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.resetPassword.tr(),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppString.resetPassword.tr(),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
