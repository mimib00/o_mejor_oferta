import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';

class OfferTile extends StatefulWidget {
  final int id;
  final Listing listing;
  const OfferTile({
    super.key,
    required this.id,
    required this.listing,
  });

  @override
  State<OfferTile> createState() => _OfferTileState();
}

class _OfferTileState extends State<OfferTile> {
  final OffersController controller = Get.find();

  bool pending = true;

  Offer? offer;

  Future<void> getOffer() async {
    final dio = Dio();
    try {
      final url = "$baseUrl/offers/${widget.listing.id}/offers/${widget.id}";
      final token = Authenticator.instance.fetchToken();

      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      offer = Offer.fromJson(res.data, widget.listing);
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOffer(),
        builder: (context, snapshot) {
          if (offer == null) return Container();
          pending = offer!.status == OfferStatus.pending;
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: kWhiteColor1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  offer!.user.name,
                  style: headline3,
                ),
                const SizedBox(height: 10),
                Text(
                  "Sent you a offer",
                  style: text1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "\$${offer!.price}",
                  style: headline1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                pending
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: MainButton(
                              onTap: () async {
                                await controller.rejectOffer(offer!.id);
                                setState(() {});
                              },
                              text: "Reject offer",
                            ),
                          ),
                          Expanded(
                            child: MainButton(
                              onTap: () async {
                                await controller.acceptOffer(offer!.id);
                                setState(() {});
                              },
                              text: "Accept offer",
                            ),
                          ),
                        ],
                      )
                    : Text(
                        offer!.status.name,
                        style: text1.copyWith(fontWeight: FontWeight.bold),
                      ),
              ],
            ),
          );
        });
  }
}
