import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingRatioOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingRatioOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          //toStringAsFixed(0) will show rounded integer
          children: [
            //* Prevent the bar from jumping or getting longer randomly
            //* when the amount of spent money is too long

            //! => Container needed to get fixed height
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text(
                  '\$${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ))),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 14,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: spendingRatioOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text(
                label,
                style: TextStyle(color: Colors.grey.shade600),
              )),
            ),
          ],
        );
      },
    );
  }
}
