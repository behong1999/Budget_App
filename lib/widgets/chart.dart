import 'package:budget_app/models/transaction.dart';
import 'package:budget_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //Getter NOTE: keys are strings, values are type object
  //* Deriving transactions of each day of week which is 7 days before today
  List<Map<String, Object>> get transactionValuesOfWeek {
    //NOTE: 7 is length of the generated list and Function(int index) generator. Meanwhile, index is in the increasing order
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var total = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          total += recentTransactions[i].amount;
        }
      }
      // print(DateFormat.E().format(weekday));
      // print(total);
      return {
        'day': DateFormat.E().format(weekday) /*.substring(0, 1)*/,
        'amount': total,
      };
    }).reversed.toList();
  }

  double get totalSpendingOfWeek {
    return transactionValuesOfWeek.fold(0.0, (sum, item) {
      return sum + (item['amount'] as num);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionValuesOfWeek.map((data) {
            //NOTE: Flexible with FlexFit.tight can be replaced by Expanded Widget with flex argument
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'] as String,
                  data['amount'] as double,
                  totalSpendingOfWeek == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpendingOfWeek),
            );
          }).toList(),
        ),
      ),
    );
  }
}
