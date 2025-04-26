import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Opportunity Lead Stage Report",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 30,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 50,
                      title: "50%",
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 16.67,
                      title: "16.7%",
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 12.5,
                      title: "12.5%",
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: 4.17,
                      title: "4.2%",
                    ),
                    PieChartSectionData(
                      color: Colors.purple,
                      value: 16.67,
                      title: "16.7%",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
