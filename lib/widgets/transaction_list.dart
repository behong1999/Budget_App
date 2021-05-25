import '../models/transaction.dart';
// NOTE: aka import 'package:budget_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  //*Constructor For the List Of Transactions
  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    //Fixed Height Of the Transaction List Container
    //height: 480,
    //List of Transactions can be scrolled within a container of 440 pixels high
    //* Because the column is not scrollable, we always need to wrap colum or row with SingleChildScrollView.
    //* Use ListView instead but it needs its limited parent's size. Otherwise, it gives unbounded size
    //! Using ListView Builder to get the best possible performance if we don't know in advance how many items we'll have
    //* The builder simply takes a number of items and repeat the builder function for every item

    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'The List Is Empty！',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/needed-adding-transaction.png',
                      fit: BoxFit.cover,
                    ))
              ],
            );
          })
        : ListView(
            //! A Must Have which gives a widget for the first, second item and the third item and so on.
            children: transactions
                .map((transaction) => TransactionItem(
                      //! With new keys generated constantly,
                      //! Flutter finds no widgets for the elements now looking for the type and key
                      //! Thus, new state objects are created all the time
                      //* Unlike UniqueKey(), ValueKey() does not calculate a random value
                      //* but simply wraps a non-changing identifier provided by you

                      key: ValueKey(transaction.id),
                      transaction: transaction,
                      deleteTransaction: deleteTransaction,
                    ))
                .toList(),

            //! Old Look
            // return Card(
            //   child: Row(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.symmetric(
            //           vertical: 10,
            //           horizontal: 20,
            //         ),
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: Colors.purple,
            //             width: 3,
            //           ),
            //         ),
            //         padding: EdgeInsets.all(10),
            //         child: Text(
            //           '\$' +
            //               transactions[index].amount.toStringAsFixed(2),
            //           /* NOTE: It can be like this '\$${tx.amount}'*/
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20,
            //               color: Theme.of(context).primaryColor),
            //         ),
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: /*<Widget>*/ [
            //           Text(
            //             transactions[index].title,
            //             style: Theme.of(context).textTheme.title,
            //           ),
            //           Text(
            //             DateFormat.yMMMMd()
            //                 .format(transactions[index].date),
            //             style: TextStyle(
            //               color: Colors.grey,
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // );
          );
  }
}
