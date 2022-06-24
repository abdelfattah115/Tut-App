import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/models.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/string_manager.dart';
import '../../resources/values_manager.dart';
import '../view_model/store_details_view-model.dart';
import '../../../app/di.dart';
import '../../resources/color_manager.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  @override
  void initState() {
    bind();
    super.initState();
  }

  bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.start();
              }) ??
              Container();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        title: Text(
          AppString.storeDetails.tr(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: ColorManager.white,
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: StreamBuilder<StoreDetails>(
            stream: _viewModel.outputStoreDetails,
            builder: (context, snapshot) {
              return _getItems(snapshot.data);
            },
          ),
        ),
      ),
    );
  }

  Widget _getItems(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              storeDetails.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AppSize.s250,
            ),
          ),
          _getSection(AppString.details.tr()),
          _getTextInfo(storeDetails.details),
          _getSection(AppString.services.tr()),
          _getTextInfo(storeDetails.services),
          _getSection(AppString.about.tr()),
          _getTextInfo(storeDetails.about),
        ],
      );
    } else{
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p12,
        left: AppPadding.p12,
        right: AppPadding.p12,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _getTextInfo(String textInfo) {
    return Padding(
      padding: const EdgeInsets.all(
        AppSize.s12,
      ),
      child: Text(
        textInfo,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
