import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:udvanced_flutter/presentation/resources/assets_manager.dart';
import 'package:udvanced_flutter/presentation/resources/color_manager.dart';
import 'package:udvanced_flutter/presentation/resources/string_manager.dart';
import 'package:udvanced_flutter/presentation/resources/styles_manager.dart';
import 'package:udvanced_flutter/presentation/resources/values_manager.dart';

enum StateRendererType {
  //popup states (Dialog)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,

  // full screen state (full screen)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // general
  contentState,
}

class StateRenderer extends StatelessWidget {
  StateRenderer(
      {Key? key,
      required this.stateRendererType,
      this.message = AppString.loading,
      this.title = '',
      required this.retryActionFunction})
      : super(key: key);

  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(context,[
          _getAnimatedImage(JsonAssets.loading),
        ]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context,[
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppString.ok.tr(),context),
        ]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppString.retryAgain.tr(),context),
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemColumn(
          [
            _getAnimatedImage(JsonAssets.empty),
            _getMessage(message),
          ]
        );
      case StateRendererType.popupSuccessState:
        return _getPopupDialog(context,
            [
              _getAnimatedImage(JsonAssets.success),
              _getMessage(title),
              _getMessage(message),
              _getRetryButton(AppString.ok.tr(), context),
            ]
        );
      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context,List<Widget> children){
    return Dialog(
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s14),
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          boxShadow: const [BoxShadow(
            color: Colors.black26,
          )],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animatedName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animatedName),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: AppSize.s18,
          ),
        ),
      ),
    );
  }

  Widget _getRetryButton(String titleButton, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType == StateRendererType.fullScreenErrorState) {
                // call retry function
                retryActionFunction.call();
              }else{
                // popup error state
                Navigator.of(context).pop();
              }
            },
            child: Text(titleButton),
          ),
        ),
      ),
    );
  }
}
