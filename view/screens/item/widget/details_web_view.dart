import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:faidanepal/controller/auth_controller.dart';
import 'package:faidanepal/controller/cart_controller.dart';
import 'package:faidanepal/controller/item_controller.dart';
import 'package:faidanepal/controller/splash_controller.dart';
import 'package:faidanepal/controller/wishlist_controller.dart';
import 'package:faidanepal/data/model/response/cart_model.dart';
import 'package:faidanepal/helper/price_converter.dart';
import 'package:faidanepal/helper/responsive_helper.dart';
import 'package:faidanepal/util/dimensions.dart';
import 'package:faidanepal/util/images.dart';
import 'package:faidanepal/util/styles.dart';
import 'package:faidanepal/view/base/confirmation_dialog.dart';
import 'package:faidanepal/view/base/custom_button.dart';
import 'package:faidanepal/view/base/custom_image.dart';
import 'package:faidanepal/view/base/custom_snackbar.dart';
import 'package:faidanepal/view/base/footer_view.dart';
import 'package:faidanepal/view/screens/item/item_details_screen.dart';
import 'package:faidanepal/view/screens/item/widget/item_title_view.dart';

class DetailsWebView extends StatelessWidget {
  final CartModel cartModel;
  final int stock;
  final double priceWithAddOns;
  const DetailsWebView(
      {@required this.cartModel,
      @required this.stock,
      @required this.priceWithAddOns});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<String> _imageList = [];
      _imageList.add(itemController.item.image);
      _imageList.addAll(itemController.item.images);

      String _baseUrl = itemController.item.availableDateStarts == null
          ? Get.find<SplashController>().configModel.baseUrls.itemImageUrl
          : Get.find<SplashController>().configModel.baseUrls.campaignImageUrl;

      return SingleChildScrollView(
          child: FooterView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 560),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 20),
            Center(
                child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 4,
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: Get.size.height * 0.5,
                                      child: CustomImage(
                                        fit: BoxFit.cover,
                                        image:
                                            '$_baseUrl/${_imageList[itemController.productSelect]}',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 70,
                                      child: itemController.item.image != null
                                          ? ListView.builder(
                                              itemCount: _imageList.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: InkWell(
                                                    onTap: () => itemController
                                                        .setSelect(index, true),
                                                    child: Container(
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .RADIUS_SMALL),
                                                        border: Border.all(
                                                            color: index ==
                                                                    itemController
                                                                        .productSelect
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                            width: index ==
                                                                    itemController
                                                                        .productSelect
                                                                ? 2
                                                                : 1),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: CustomImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            '$_baseUrl/${_imageList[index]}',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox(),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(width: 40),
                          Expanded(
                              flex: 6,
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ItemTitleView(item: itemController.item),
                                      SizedBox(height: 35),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: itemController
                                            .item.choiceOptions.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    itemController
                                                        .item
                                                        .choiceOptions[index]
                                                        .title,
                                                    style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 20,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 6.5
                                                            : (1 / 0.25),
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: itemController
                                                      .item
                                                      .choiceOptions[index]
                                                      .options
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        itemController
                                                            .setCartVariationIndex(
                                                                index,
                                                                i,
                                                                itemController
                                                                    .item);
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: itemController
                                                                          .variationIndex[
                                                                      index] !=
                                                                  i
                                                              ? Theme.of(
                                                                      context)
                                                                  .disabledColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: itemController
                                                                          .variationIndex[
                                                                      index] !=
                                                                  i
                                                              ? Border.all(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                  width: 2)
                                                              : null,
                                                        ),
                                                        child: Text(
                                                          itemController
                                                              .item
                                                              .choiceOptions[
                                                                  index]
                                                              .options[i]
                                                              .trim(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: robotoRegular
                                                              .copyWith(
                                                            color: itemController
                                                                            .variationIndex[
                                                                        index] !=
                                                                    i
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                    height: index !=
                                                            itemController
                                                                    .item
                                                                    .choiceOptions
                                                                    .length -
                                                                1
                                                        ? Dimensions
                                                            .PADDING_SIZE_LARGE
                                                        : 0),
                                              ]);
                                        },
                                      ),
                                      SizedBox(height: 30),
                                      Row(children: [
                                        QuantityButton(
                                          isIncrement: false,
                                          quantity: itemController.cartIndex !=
                                                  -1
                                              ? Get.find<CartController>()
                                                  .cartList[
                                                      itemController.cartIndex]
                                                  .quantity
                                              : itemController.quantity,
                                          stock: stock,
                                          isExistInCart:
                                              itemController.cartIndex != -1,
                                          cartIndex: itemController.cartIndex,
                                        ),
                                        SizedBox(width: 30),
                                        GetBuilder<CartController>(
                                            builder: (cartController) {
                                          return Text(
                                            itemController.cartIndex != -1
                                                ? cartController
                                                    .cartList[itemController
                                                        .cartIndex]
                                                    .quantity
                                                    .toString()
                                                : itemController.quantity
                                                    .toString(),
                                            style: robotoBold.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraLarge),
                                          );
                                        }),
                                        SizedBox(width: 30),
                                        QuantityButton(
                                          isIncrement: true,
                                          quantity: itemController.cartIndex !=
                                                  -1
                                              ? Get.find<CartController>()
                                                  .cartList[
                                                      itemController.cartIndex]
                                                  .quantity
                                              : itemController.quantity,
                                          stock: stock,
                                          cartIndex: itemController.cartIndex,
                                          isExistInCart:
                                              itemController.cartIndex != -1,
                                        ),
                                      ]),
                                      SizedBox(height: 30),
                                      Row(children: [
                                        Text('${'total_amount'.tr}:',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                        SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        Text(
                                            PriceConverter.convertPrice(
                                                priceWithAddOns ?? 0.0),
                                            style: robotoBold.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            )),
                                      ]),
                                      SizedBox(height: 30),
                                      SizedBox(
                                          width: 400,
                                          child: Row(children: [
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL),
                                                ),
                                                child: GetBuilder<
                                                        WishListController>(
                                                    builder: (wishController) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (Get.find<
                                                              AuthController>()
                                                          .isLoggedIn()) {
                                                        if (wishController
                                                            .wishItemIdList
                                                            .contains(
                                                                itemController
                                                                    .item.id)) {
                                                          wishController
                                                              .removeFromWishList(
                                                                  itemController
                                                                      .item.id,
                                                                  false);
                                                        } else {
                                                          wishController
                                                              .addToWishList(
                                                                  itemController
                                                                      .item,
                                                                  null,
                                                                  false);
                                                        }
                                                      } else
                                                        showCustomSnackBar(
                                                            'you_are_not_logged_in'
                                                                .tr);
                                                    },
                                                    child: Icon(
                                                      wishController
                                                              .wishItemIdList
                                                              .contains(
                                                                  itemController
                                                                      .item.id)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: 25,
                                                      color: wishController
                                                              .wishItemIdList
                                                              .contains(
                                                                  itemController
                                                                      .item.id)
                                                          ? Theme.of(context)
                                                              .cardColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ])),
                                      (itemController.item.description !=
                                                  null &&
                                              itemController
                                                  .item.description.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                Text('description'.tr,
                                                    style: robotoMedium),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                Text(
                                                    itemController
                                                        .item.description,
                                                    style: robotoRegular),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                              ],
                                            )
                                          : SizedBox(),
                                    ]),
                              )),
                        ]))),
          ]),
        ),
      ));
    });
  }
}
