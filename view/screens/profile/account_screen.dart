import 'package:faidanepal/data/model/response/config_model.dart';
import 'package:faidanepal/view/screens/auth/widget/forms/buttons.dart';
import 'package:faidanepal/view/screens/language/widget/language_widget.dart';
import 'package:faidanepal/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/ui_assets.dart';
import '../../base/custom_image.dart';
import '../address/address_screen.dart';
import '../chat/conversation_screen.dart';
import '../coupon/coupon_screen.dart';
import '../dashboard/widget/size_constants.dart';
import '../support/support_screen.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key key}) : super(key: key);

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
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
    return Scaffold(body: GetBuilder<UserController>(builder: (userController) {
      return (_isLoggedIn && userController.userInfoModel == null)
          ? Center(child: CircularProgressIndicator())
          : ProfileBgWidget(
              backButton: true,
              circularImage: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 2, color: Theme.of(context).cardColor),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: ClipOval(
                  child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                        '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              mainWidget: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: SC.lW, vertical: SC.sH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SBC.xLW,
                      SBC.xLH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(214, 40, 40, 0.2),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 7),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      // child: Image.asset(
                                      //   UIAssets.getDummyImage('k1.png'),
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SBC.mH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getAddressRoute());
                        },
                        child: _settingFeatures(
                          title: "My Address",
                          image: "loc.png",
                        ),
                      ),
                      SBC.sH,
                      // _settingFeatures(
                      //   title: "Language",
                      //   image: "lg.png",
                      // ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getCouponRoute());
                        },
                        child: _settingFeatures(
                          title: "Coupon",
                          image: "c.png",
                        ),
                      ),
                      SBC.sH,
                      _settingFeatures(
                        title: "Help and Support",
                        image: "help.png",
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getHtmlRoute('privacy-policy'));
                        },
                        child: _settingFeatures(
                          title: "Privacy Policy",
                          image: "p.png",
                        ),
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getHtmlRoute('about-us'));
                        },
                        child: _settingFeatures(
                          title: "About Us",
                          image: "about_us.png",
                        ),
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getHtmlRoute('terms-and-condition'));
                        },
                        child: _settingFeatures(
                          title: "Terms and Conditions",
                          image: "term.png",
                        ),
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getConversationRoute());
                        },
                        child: _settingFeatures(
                          title: "Live Chat",
                          image: "chat.png",
                        ),
                      ),
                      SBC.sH,
                      _settingFeatures(
                        title: "Refer & Earn",
                        image: "ref.png",
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getWalletRoute(true));
                        },
                        child: _settingFeatures(
                          title: "Wallet",
                          image: "wall.png",
                        ),
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getWalletRoute(true));
                        },
                        child: _settingFeatures(
                          title: "Loyalty Points",
                          image: "loy.png",
                        ),
                      ),
                      SBC.sH,
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getDeliverymanRegistrationRoute());
                        },
                        child: _settingFeatures(
                          title: "Join as a Delivery Man",
                          image: "de.png",
                        ),
                      ),
                      SBC.sH,
                      _settingFeatures(
                        title: "Join as Store",
                        image: "store.png",
                      ),
                      SBC.lH,
                      PrimaryButton(
                        radius: 10,
                        title: "Log Out",
                      )
                    ],
                  ),
                ),
              ),
            );
    }));
  }
}

class _settingFeatures extends StatelessWidget {
  final String title;
  final String image;
  _settingFeatures({
    this.title,
    this.image,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SBC.sW,
          Image.asset(UIAssets.getDummyImage(image)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SC.lH),
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: const Color.fromRGBO(5, 53, 53, 1),
                    fontSize: 11,
                  ),
            ),
          ),
          // const SizedBox(
          //   width: 150,
          // ),
          // const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 10,
          // ),
        ],
      ),
    );
  }
}

class _LoginoutButton extends StatelessWidget {
  const _LoginoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "5.38.2(2023)",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          "powered by 21st Tech",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
