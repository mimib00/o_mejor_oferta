import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/packages.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/boost/components/package_tile.dart';

class MembershipScreen extends StatelessWidget {
  final Category category;
  const MembershipScreen({
    super.key,
    required this.category,
  });

  Future<List<Packages>> getPackages() async {
    try {
      final dio = Dio();

      const url = "$baseUrl/payments/packages/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Packages> packages = [];
      for (var package in res.data) {
        if (package["package_type"] != "NSFW_CONTENT") continue;
        packages.add(Packages.fromJson(package));
      }
      return packages;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: category.photo ?? "",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Container(
                          alignment: Alignment.center,
                          color: kPrimaryColor,
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category.name,
                    style: text1,
                  )
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Select package",
              style: headline3,
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<Packages>>(
              future: getPackages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());

                if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

                final packages = snapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: packages.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    itemExtent: 200,
                    itemBuilder: (context, index) {
                      return NsfwPackageTile(package: packages[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
