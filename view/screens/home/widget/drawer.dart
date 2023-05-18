import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/location_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../data/model/response/address_model.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_loader.dart';
import '../../../base/title_widget.dart';
import '../../address/widget/address_widget.dart';
import 'module_view.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  @override
  void initState() {
    super.initState();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade400,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: TitleWidget(title: 'deliver_to'.tr),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                GetBuilder<LocationController>(builder: (locationController) {
                  List<AddressModel> _addressList = [];
                  if (Get.find<AuthController>().isLoggedIn() &&
                      locationController.addressList != null) {
                    _addressList = [];
                    bool _contain = false;
                    if (locationController.getUserAddress().id != null) {
                      for (int index = 0;
                          index < locationController.addressList.length;
                          index++) {
                        if (locationController.addressList[index].id ==
                            locationController.getUserAddress().id) {
                          _contain = true;
                          break;
                        }
                      }
                    }
                    if (!_contain) {
                      _addressList
                          .add(Get.find<LocationController>().getUserAddress());
                    }
                    _addressList.addAll(locationController.addressList);
                  } else {
                    _addressList
                        .add(Get.find<LocationController>().getUserAddress());
                  }
                  return (!Get.find<AuthController>().isLoggedIn() ||
                          locationController.addressList != null)
                      ? SizedBox(
                          height: 70,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _addressList.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 300,
                                padding: EdgeInsets.only(
                                    right: Dimensions.PADDING_SIZE_SMALL),
                                child: AddressWidget(
                                  address: _addressList[index],
                                  fromAddress: false,
                                  onTap: () {
                                    if (locationController
                                            .getUserAddress()
                                            .id !=
                                        _addressList[index].id) {
                                      Get.dialog(CustomLoader(),
                                          barrierDismissible: false);
                                      locationController.saveAddressAndNavigate(
                                        _addressList[index],
                                        false,
                                        null,
                                        false,
                                        ResponsiveHelper.isDesktop(context),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : AddressShimmer(
                          isEnabled: Get.find<AuthController>().isLoggedIn() &&
                              locationController.addressList == null);
                }),
              ],
            ),
          ),
          Text(
            _isLoggedIn
                ? '${Get.find<UserController>().userInfoModel.fName} ${Get.find<UserController>().userInfoModel.lName}'
                : 'guest'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          Text(
            _isLoggedIn
                ? '${Get.find<UserController>().userInfoModel.email} '
                : 'guest'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ],
      ),
    );
  }
}
