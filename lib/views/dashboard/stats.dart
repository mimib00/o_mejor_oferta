import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/stats.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/dashboard/controller/dashboard_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StatsScreen extends GetView<DashboardController> {
  const StatsScreen({super.key});

  Widget bottomTitleWidgets(List<Stats> stats, double value, TitleMeta meta) {
    if (value.round() == 0) return const Text("");
    return Text(stats[value.round() - 1].day);
  }

  @override
  Widget build(BuildContext context) {
    final listing = controller.listing;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: listing!.images.first,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: text1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "\$${listing.price}",
                        style: headline3,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<Stats>>(
              future: controller.getStats(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total views :",
                              style: text1.copyWith(color: kWhiteColor6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${controller.total}",
                              style: headline1.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: LineChart(
                            LineChartData(
                              maxX: 0,
                              maxY: controller.total.toDouble(),
                              minY: 0,
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey,
                                    strokeWidth: 0.5,
                                    dashArray: [3, 6],
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                border: const Border(),
                              ),
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) => Container(),
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) => Container(),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) => Text(value.round().toString()),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) => bottomTitleWidgets([], value, meta),
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  dotData: FlDotData(
                                    show: false,
                                  ),
                                  show: true,
                                  curveSmoothness: .5,
                                  isCurved: true,
                                  color: kPrimaryColor,
                                  barWidth: 3,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        kPrimaryColor50,
                                        kPrimaryColor.withOpacity(0),
                                      ],
                                      stops: const [.1, 1],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final stats = snapshot.data!;
                List<FlSpot> spots = [];

                for (var i = 0; i < stats.length; i++) {
                  spots.add(FlSpot(i.toDouble(), stats[i].count.toDouble()));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total views :",
                            style: text1.copyWith(color: kWhiteColor6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${controller.total}",
                            style: headline1.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            maxX: stats.length.toDouble(),
                            maxY: controller.total.toDouble(),
                            minY: 0,
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.black,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map(
                                    (barSpot) {
                                      return LineTooltipItem(
                                        barSpot.y.round().toString(),
                                        text2.copyWith(color: Colors.white),
                                      );
                                    },
                                  ).toList();
                                },
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.5,
                                  dashArray: [3, 6],
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              border: const Border(),
                            ),
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Container(),
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 2,
                                  getTitlesWidget: (value, meta) => Container(),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) => Text(value.round().toString()),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  interval:
                                      (stats.length / 3).roundToDouble() <= 0 ? .5 : (stats.length / 3).roundToDouble(),
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => bottomTitleWidgets(stats, value, meta),
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                dotData: FlDotData(
                                  show: false,
                                ),
                                show: true,
                                curveSmoothness: .5,
                                isCurved: true,
                                color: kPrimaryColor,
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      kPrimaryColor50,
                                      kPrimaryColor.withOpacity(0),
                                    ],
                                    stops: const [.1, 1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                spots: spots,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(Routes.boost, arguments: listing),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
                    textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                  ),
                  label: const Text("Boost Plus"),
                  icon: const Icon(Icons.keyboard_double_arrow_up_sharp),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Get an average of 20x more views each day",
              style: text1.copyWith(color: kWhiteColor6),
            )
          ],
        ),
      ),
    );
  }
}
