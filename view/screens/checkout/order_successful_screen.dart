import 'dart:async';

import 'package:faidanepal/controller/order_controller.dart';
import 'package:faidanepal/controller/splash_controller.dart';
import 'package:faidanepal/controller/theme_controller.dart';
import 'package:faidanepal/helper/responsive_helper.dart';
import 'package:faidanepal/helper/route_helper.dart';
import 'package:faidanepal/util/dimensions.dart';
import 'package:faidanepal/util/images.dart';
import 'package:faidanepal/util/styles.dart';
import 'package:faidanepal/view/base/custom_button.dart';
import 'package:faidanepal/view/base/footer_view.dart';
import 'package:faidanepal/view/base/menu_drawer.dart';
import 'package:faidanepal/view/base/web_menu_bar.dart';
import 'package:faidanepal/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String orderID;
  OrderSuccessfulScreen({@required this.orderID});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<OrderController>()
        .trackOrder(widget.orderID.toString(), null, false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Get.offAllNamed(RouteHelper.getInitialRoute());
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        endDrawer: MenuDrawer(),
        body: GetBuilder<OrderController>(builder: (orderController) {
          double total = 0;
          bool success = true;
          bool parcel = false;
          if (orderController.trackModel != null) {
            total = ((orderController.trackModel.orderAmount / 100) *
                Get.find<SplashController>()
                    .configModel
                    .loyaltyPointItemPurchasePoint);
            success = orderController.trackModel.paymentStatus == 'paid' ||
                orderController.trackModel.paymentMethod == 'cash_on_delivery';
            parcel = orderController.trackModel.paymentMethod == 'parcel';

            if (!success) {
              Future.delayed(Duration(seconds: 1), () {
                Get.dialog(PaymentFailedDialog(orderID: widget.orderID),
                    barrierDismissible: false);
              });
            }
          }

          return orderController.trackModel != null
              ? Center(
                  child: SingleChildScrollView(
                    child: FooterView(
                        child: SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      success ? Images.checked : Images.warning,
                                      width: 100,
                                      height: 100),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),
                                  Text(
                                    success
                                        ? parcel
                                            ? 'you_placed_the_parcel_request_successfully'
                                                .tr
                                            : 'you_placed_the_order_successfully'
                                                .tr
                                        : 'your_order_is_failed_to_place'.tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_LARGE,
                                        vertical:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    child: Text(
                                      success
                                          ? parcel
                                              ? 'your_parcel_request_is_placed_successfully'
                                                  .tr
                                              : 'your_order_is_placed_successfully'
                                                  .tr
                                          : 'your_order_is_failed_to_place_because'
                                              .tr,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  (success &&
                                          Get.find<SplashController>()
                                                  .configModel
                                                  .loyaltyPointStatus ==
                                              1 &&
                                          total.floor() > 0)
                                      ? Column(children: [
                                          Image.asset(
                                              Get.find<ThemeController>()
                                                      .darkTheme
                                                  ? Images.gift_box1
                                                  : Images.gift_box,
                                              width: 150,
                                              height: 150),
                                          Text('congratulations'.tr,
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            child: Text(
                                              'you_have_earned'.tr +
                                                  ' ${total.floor().toString()} ' +
                                                  'points_it_will_add_to'.tr,
                                              style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ])
                                      : SizedBox.shrink(),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomButton(
                                        buttonText: 'back_to_home'.tr,
                                        onPressed: () => Get.offAllNamed(
                                            RouteHelper.getInitialRoute())),
                                  ),
                                ]))),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
