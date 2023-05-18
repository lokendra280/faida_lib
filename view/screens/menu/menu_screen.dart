import 'package:faidanepal/controller/auth_controller.dart';
import 'package:faidanepal/controller/splash_controller.dart';
import 'package:faidanepal/data/model/response/menu_model.dart';
import 'package:faidanepal/helper/responsive_helper.dart';
import 'package:faidanepal/helper/route_helper.dart';
import 'package:faidanepal/util/dimensions.dart';
import 'package:faidanepal/util/images.dart';
import 'package:faidanepal/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuModel> _menuList;
  double _ratio;

  @override
  Widget build(BuildContext context) {
    _ratio = ResponsiveHelper.isDesktop(context)
        ? 1.1
        : ResponsiveHelper.isTab(context)
            ? 1.1
            : 1.2;
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    _menuList = [
      MenuModel(
          icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(
          icon: Images.location,
          title: 'my_address'.tr,
          route: RouteHelper.getAddressRoute()),
      MenuModel(
          icon: Images.language,
          title: 'language'.tr,
          route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(
          icon: Images.coupon,
          title: 'coupon'.tr,
          route: RouteHelper.getCouponRoute()),
      MenuModel(
          icon: Images.support,
          title: 'help_support'.tr,
          route: RouteHelper.getSupportRoute()),
      MenuModel(
          icon: Images.policy,
          title: 'privacy_policy'.tr,
          route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(
          icon: Images.about_us,
          title: 'about_us'.tr,
          route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(
          icon: Images.terms,
          title: 'terms_conditions'.tr,
          route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(
          icon: Images.chat,
          title: 'live_chat'.tr,
          route: RouteHelper.getConversationRoute()),
    ];

    if (Get.find<SplashController>().configModel.refEarningStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.refer_code,
          title: 'refer_and_earn'.tr,
          route: RouteHelper.getReferAndEarnRoute()));
    }
    if (Get.find<SplashController>().configModel.customerWalletStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.wallet,
          title: 'wallet'.tr,
          route: RouteHelper.getWalletRoute(true)));
    }
    if (Get.find<SplashController>().configModel.loyaltyPointStatus == 1) {
      _menuList.add(MenuModel(
          icon: Images.loyal,
          title: 'loyalty_points'.tr,
          route: RouteHelper.getWalletRoute(false)));
    }
    if (Get.find<SplashController>().configModel.toggleDmRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.delivery_man_join,
        title: 'join_as_a_delivery_man'.tr,
        route: RouteHelper.getDeliverymanRegistrationRoute(),
      ));
    }
    if (Get.find<SplashController>().configModel.toggleStoreRegistration &&
        !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.restaurant_join,
        title: Get.find<SplashController>()
                .configModel
                .moduleConfig
                .module
                .showRestaurantText
            ? 'join_as_a_restaurant'.tr
            : 'join_as_a_store'.tr,
        route: RouteHelper.getRestaurantRegistrationRoute(),
      ));
    }
    _menuList.add(MenuModel(
        icon: Images.log_out,
        title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
        route: ''));

    return PointerInterceptor(
      child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context)
                  ? 8
                  : ResponsiveHelper.isTab(context)
                      ? 6
                      : 4,
              childAspectRatio: (1 / _ratio),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(
                  menu: _menuList[index],
                  isProfile: index == 0,
                  isLogout: index == _menuList.length - 1);
            },
          ),
          SizedBox(
              height: ResponsiveHelper.isMobile(context)
                  ? Dimensions.PADDING_SIZE_SMALL
                  : 0),
        ]),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:faidanepal/controller/splash_controller.dart';
// import 'package:faidanepal/controller/user_controller.dart';

// import '../../../controller/auth_controller.dart';
// import '../../../data/model/response/userinfo_model.dart';
// import '../../../helper/route_helper.dart';
// import '../../../util/images.dart';
// import '../auth/widget/ui_assets.dart';
// import '../dashboard/widget/size_constants.dart';

// class MenuScreen extends StatefulWidget {
//   const MenuScreen({Key key}) : super(key: key);

//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }

// class _MenuScreenState extends State<MenuScreen> {
//   bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

//   @override
//   void initState() {
//     super.initState();

//     if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
//       Get.find<UserController>().getUserInfo();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           "Profile",
//           style: Theme.of(context).textTheme.headline6,
//         ),
//         actions: [Icon(Icons.arrow_back_ios)],
//         // leading: IconButton(
//         //   onPressed: () {},
//         //   icon: SvgPicture.asset(
//         //     UIAssets.getSvg('ham.svg'),
//         //     color: Colors.black,
//         //   ),
//         // ),
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {},
//         //     icon: SvgPicture.asset(
//         //       UIAssets.getSvg('notification.svg'),
//         //       color: Colors.black,
//         //     ),
//         //   ),
//         // ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding:
//               const EdgeInsets.symmetric(horizontal: SC.mW, vertical: SC.mH),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SBC.xxLH,
//               Row(
//                 children: [
//                   Stack(children: [
//                     // Positioned(
//                     //   top: 20,
//                     //     left: 20,
//                     //     child: Container(
//                     //       height: 20,
//                     //       width: 20,
//                     //       decoration: BoxDecoration(
//                     //         color: primaryColor,
//                     //         border: Border.all(
//                     //           width: 0.2,
//                     //         ),
//                     //         borderRadius: BorderRadius.circular(50),
//                     //       ),
//                     //       child: IconButton(onPressed: (){}, icon: SvgPicture.asset(UIAssets.getSvg('edit_icon.svg'))))),
//                   ]),
//                   SBC.xXlW,
//                 ],
//               ),
//               const Divider(),
//               SBC.mH,
//               InkWell(
//                   onTap: () {
//                     Get.toNamed(RouteHelper.getProfileRoute());
//                   },
//                   child: _ProfileSettings(
//                     icon: Images.location,
//                     title: 'profile',
//                   )),
//               InkWell(
//                   onTap: () {
//                     Get.toNamed(RouteHelper.getAddressRoute());
//                   },
//                   child: _ProfileSettings(
//                     icon: Images.location,
//                     title: 'my_address',
//                   )),
//               SBC.xxLH,
//               const _Heading(
//                 title: 'Features',
//               ),
//               SBC.xxLH,
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getCouponRoute());
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'settings_icon.svg',
//                   title: 'coupon',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getWalletRoute(true));
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'settings_icon.svg',
//                   title: 'wallet',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getWalletRoute(true));
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'settings_icon.svg',
//                   title: 'loyalty_points',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'settings_icon.svg',
//                   title: 'join_as_a_delivery_man',
//                 ),
//               ),
//               SBC.xxLH,
//               const _Heading(
//                 title: 'App Settings',
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getConversationRoute());
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'help_icon.svg',
//                   title: 'live_chat',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition'));
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'help_icon.svg',
//                   title: 'terms_conditions',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getHtmlRoute('about-us'));
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'feedback_icon.svg',
//                   title: 'about_us',
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy'));
//                 },
//                 child: const _ProfileSettings(
//                   icon: 'rate_icon.svg',
//                   title: 'privacy_policy',
//                 ),
//               ),
//               SBC.xxLH,
//               SBC.xxLH,
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: SC.mW, vertical: SC.mH),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         // context.router.push(const SecondaryLoginRoute());
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SvgPicture.asset(UIAssets.getSvg('exit_icon.svg')),
//                           SBC.xLW,
//                           Text(
//                             'Sign out',
//                             style: Theme.of(context).textTheme.bodyText2,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       'lorem@gmail.com',
//                       style: Theme.of(context).textTheme.caption,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ProfileSettings extends StatelessWidget {
//   final String icon;
//   final String title;
//   final String route;

//   const _ProfileSettings({
//     this.icon,
//     this.title,
//     this.route,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: SC.mW, vertical: SC.mH),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SvgPicture.asset(UIAssets.getSvg(icon)),
//               SBC.xLW,
//               Text(
//                 title.tr,
//                 style: Theme.of(context).textTheme.bodyText2,
//               ),
//             ],
//           ),
//           const Icon(Icons.arrow_forward_ios),
//         ],
//       ),
//     );
//   }
// }

// class _Heading extends StatelessWidget {
//   final String title;
//   const _Heading({
//     this.title,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title.tr,
//       style: Theme.of(context).textTheme.bodyText1,
//     );
//   }
// }
