import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:faidanepal/controller/auth_controller.dart';
import 'package:faidanepal/controller/banner_controller.dart';
import 'package:faidanepal/controller/location_controller.dart';
import 'package:faidanepal/controller/splash_controller.dart';
import 'package:faidanepal/controller/store_controller.dart';

import 'package:faidanepal/helper/responsive_helper.dart';
import 'package:faidanepal/util/dimensions.dart';
import 'package:faidanepal/util/styles.dart';
import 'package:faidanepal/view/base/custom_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:faidanepal/view/screens/auth/widget/forms/buttons.dart';
import 'package:faidanepal/view/screens/home/widget/banner_view.dart';

import 'package:faidanepal/view/screens/home/widget/popular_item_view.dart';
import 'package:faidanepal/view/screens/home/widget/popular_product_view.dart';
import 'package:faidanepal/view/screens/home/widget/popular_store_view.dart';

import '../../../../controller/campaign_controller.dart';
import '../../../../controller/category_controller.dart';
import '../../../../controller/item_controller.dart';
import '../../../../controller/notification_controller.dart';
import '../../../../controller/parcel_controller.dart';
import '../../../../controller/user_controller.dart';

import '../../dashboard/widget/size_constants.dart';


class ModuleView extends StatefulWidget {
    static Future<void> loadData(bool reload) async {
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel
            .moduleConfig
            .module
            .isParcel) {
      Get.find<BannerController>().getBannerList(reload);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().configModel.moduleConfig.module.isParcel) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }
  final SplashController splashController;
  ModuleView({@required this.splashController});

  @override
  State<ModuleView> createState() => _ModuleViewState();
}

class _ModuleViewState extends State<ModuleView> {
  final ScrollController _scrollController = ScrollController();
  // List<Store> _storeList = isPopular ? storeController.popularStoreList : storeController.latestStoreList;

  // var _isViewMore = true;
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
        ),

        GetBuilder<BannerController>(builder: (bannerController) {
          return BannerView(isFeatured: true);
        }),

        widget.splashController.moduleList != null
            ? widget.splashController.moduleList.length > 0
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                      crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                      childAspectRatio: (1 / 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _isExpanded
                        ? widget.splashController.moduleList.length
                        : 4,
                    // itemCount: widget.splashController.moduleList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            widget.splashController.changeModule(index, true),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.RADIUS_DEFAULT),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 700 : 200],
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  child: CustomImage(
                                    image:
                                        '${widget.splashController.configModel.baseUrls.moduleImageUrl}/${widget.splashController.moduleList[index].icon}',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Center(
                                    child: Text(
                                  widget.splashController.moduleList[index]
                                      .moduleName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                )),
                              ]),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                    padding:
                        EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    child: Text('no_module_found'.tr),
                  ))
            : ModuleShimmer(
                isEnabled: widget.splashController.moduleList == null),

        SBC.xLH,
        Center(
          child: PrimaryButton(
            width: 80,
            height: 35,
            radius: 20,
            color: Colors.red.shade300,
            icon: Icon(Icons.keyboard_arrow_down),
            title: _isExpanded ? 'View Less' : 'View More',
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        // Text('Limited Offers'),
        SBC.lH,
        Divider(
          thickness: 8,
        ),
        SBC.lH,
        // Padding(
        //   padding:
        //       EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        //   child: Text(
        //     'Limited Offers'.tr,
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodyText1
        //         .copyWith(fontWeight: FontWeight.w500, fontSize: 17),
        //   ),
        // ),
        // SBC.mH,
        // Padding(
        //     padding: const EdgeInsets.symmetric(
        //         horizontal: Dimensions.PADDING_SIZE_SMALL),
        //     child: CustomImage(
        //       image:
        //           '${Get.find<SplashController>().configModel.baseUrls.bannerImageUrl}',
        //     )),
        // SBC.lH,
        // Divider(
        //   thickness: 8,
        // ),
        // CategoryView(),

        PopularStoreView(isPopular: false, isFeatured: true),

        Divider(
          thickness: 5,
        ),
        PopularItemView(isPopular: false, ),
        Divider(
          thickness: 5,
        ),
        SBC.lH,
        // Padding(
        //   padding:
        //       EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        //   child: TitleWidget(title: 'deliver_to'.tr),
        // ),
        // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        // GetBuilder<LocationController>(builder: (locationController) {
        //   List<AddressModel> _addressList = [];
        //   if (Get.find<AuthController>().isLoggedIn() &&
        //       locationController.addressList != null) {
        //     _addressList = [];
        //     bool _contain = false;
        //     if (locationController.getUserAddress().id != null) {
        //       for (int index = 0;
        //           index < locationController.addressList.length;
        //           index++) {
        //         if (locationController.addressList[index].id ==
        //             locationController.getUserAddress().id) {
        //           _contain = true;
        //           break;
        //         }
        //       }
        //     }
        //     if (!_contain) {
        //       _addressList.add(Get.find<LocationController>().getUserAddress());
        //     }
        //     _addressList.addAll(locationController.addressList);
        //   } else {
        //     _addressList.add(Get.find<LocationController>().getUserAddress());
        //   }
        //   return (!Get.find<AuthController>().isLoggedIn() ||
        //           locationController.addressList != null)
        //       ? SizedBox(
        //           height: 70,
        //           child: ListView.builder(
        //             physics: BouncingScrollPhysics(),
        //             itemCount: _addressList.length,
        //             scrollDirection: Axis.horizontal,
        //             padding: EdgeInsets.symmetric(
        //                 horizontal: Dimensions.PADDING_SIZE_SMALL),
        //             itemBuilder: (context, index) {
        //               return Container(
        //                 width: 300,
        //                 padding: EdgeInsets.only(
        //                     right: Dimensions.PADDING_SIZE_SMALL),
        //                 child: AddressWidget(
        //                   address: _addressList[index],
        //                   fromAddress: false,
        //                   onTap: () {
        //                     if (locationController.getUserAddress().id !=
        //                         _addressList[index].id) {
        //                       Get.dialog(CustomLoader(),
        //                           barrierDismissible: false);
        //                       locationController.saveAddressAndNavigate(
        //                         _addressList[index],
        //                         false,
        //                         null,
        //                         false,
        //                         ResponsiveHelper.isDesktop(context),
        //                       );
        //                     }
        //                   },
        //                 ),
        //               );
        //             },
        //           ),
        //         )
        //       : AddressShimmer(
        //           isEnabled: Get.find<AuthController>().isLoggedIn() &&
        //               locationController.addressList == null);
        // }),
        Divider(
          thickness: 5,
        ),
        // SBC.mH,
        BannerView(isFeatured: false),
        Divider(
          thickness: 5,
        ),
        // // PopularProductView(isPopular: false, isFeatured: true),
        // // AddsScreen(),
        // Divider(
        //   thickness: 5,
        // ),
        PopularProductView(isPopular: false, isFeatured: false),

        // // PopularStoreShimmer(storeController: false),
        // SizedBox(height: 30),

                                // SliverToBoxAdapter(
                                //   child: Center(
                                //       child: SizedBox(
                                //     width: Dimensions.WEB_MAX_WIDTH,
                                //     child: !_showMobileModule
                                //         ? Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //                 BannerView(isFeatured: false),
                                //                 CategoryView(),
                                //                 PopularStoreView(
                                //                     isPopular: true,
                                //                     isFeatured: false),
                                //                 PopularItemView(
                                //                     isPopular: true),
                                //                 PopularStoreView(
                                //                     isPopular: false,
                                //                     isFeatured: false),
                                //                 PopularItemView(
                                //                     isPopular: false),
                                //                // AddsScreen(),
                  
                                //               ]);
            
                                //   )
                                //   ),
                                // ),
      ]),
    );
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  ModuleShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
        crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
        childAspectRatio: (1 / 1),
      ),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      itemCount: 6,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 200],
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[300]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  AddressShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                  ? Dimensions.PADDING_SIZE_DEFAULT
                  : Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[Get.isDarkMode ? 800 : 200],
                      blurRadius: 5,
                      spreadRadius: 1)
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  Icons.location_on,
                  size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Shimmer(
                    duration: Duration(seconds: 2),
                    enabled: isEnabled,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 15, width: 100, color: Colors.grey[300]),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                              height: 10, width: 150, color: Colors.grey[300]),
                        ]),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
