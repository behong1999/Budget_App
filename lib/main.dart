import 'package:budget_app/widgets/chart.dart';
import 'package:budget_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'package:budget_app/widgets/new_transaction.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';

void main() {
  // //NOTE: This Line must be included before using SystemChrome object
  // WidgetsFlutterBinding.ensureInitialized();
  // //NOTE: These lines won't make the app go into landscape mode
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amberAccent,
          fontFamily: 'Quicksand',

          //NOTE: The text must include the style to have this theme
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),

          //NOTE: These Lines will be applied to all the text within the appbar and the appbar in general
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 22,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //*This function is used to show a bottom sheet to add new transaction
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Gundam',
    //   amount: 69.69,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.54,
    //   date: DateTime.now(),
    // ),
  ];

  //NOTE: Create a list of recent transactions to show on the chart
  List<Transaction> get _recentTransactions {
    //* where method runs a function on every item in a list and returns a iterable with the elements satisfying the predicate
    return _userTransactions.where((transaction) {
      // NOTE: Only transactions younger than 7 days are included
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String titleTx, double amountTx, DateTime pickedDate) {
    final newTx = Transaction(
      title: titleTx,
      amount: amountTx,
      date: pickedDate,
      id: DateTime.now().toString(), // id is a String
    );

    //NOTE: setState(void Function() fn) => need to create an anonymous function
    setState(
      () {
        _userTransactions
            .add(newTx); // Add new transaction into the user transaction list
      },
    );
  }

  //NOTE: Show bottom sheet for users to add new transaction
  void _startToAddNew(BuildContext ctx) {
    //! Method
    showModalBottomSheet(
      context: ctx,
      builder: (bContext) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          //NOTE: These lines will not make the sheet close when the sheet is tapped
          // And it will be closed only when tapping the other places
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    //! Definitions
    final mediaQuery = MediaQuery.of(context);

    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    //* appBar will be stored in a variable and can be accessed anywhere
    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
            onPressed: () => _startToAddNew(context),
            icon: Icon(Icons.add_box)),
      ],
    );

    final transactionListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    List<Widget> _buildPortraitMode(
      AppBar appBar,
      MediaQueryData mediaQuery,
      Widget transactionListWidget,
    ) {
      return [
        Container(
            //NOTE: Deduct the appBar's and NOTIFICATION BAR's height
            // to get all the remaining spaces of the device screen for the chart
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.3,
            child: Chart(_recentTransactions)),
        transactionListWidget
      ];
    }

    List<Widget> _buildLandscapeMode(
      AppBar appBar,
      MediaQueryData mediaQuery,
      Widget transactionListWidget,
    ) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            //* Create an adaptive switch for IOS devices
            Switch.adaptive(
                // activeColor: Theme.of(context).accentColor,
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                })
          ],
        ),
        _showChart
            ? Container(
                //NOTE: Deduct the appBar's and NOTIFICATION BAR's height
                // to get all the remaining spaces of the device screen for the chart
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.6,
                child: Chart(_recentTransactions),
              )
            : transactionListWidget,
      ];
    }

    //! Returned Widgets
    return Scaffold(
      appBar: appBar,

      //* The keyboard pushes the page up which leads to exceeded page boundaries.
      //* To solve the exceeded page warning showing up, use SingleChildScrollView

      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          //* There cannot be a list of list of widget so that's why we need spread operator
          children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   child: Card(
            //     color: Colors.blue[400],
            //     child: Text(
            //       'CHART',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     elevation: 5,
            //   ),
            // ),

            //! Check Landscape Mode
            //* spread operator (...) transforms list of widgets into widgets specifically 2 individual widgets
            if (isLandscape)
              ..._buildLandscapeMode(appBar, mediaQuery, transactionListWidget),
            if (!isLandscape)
              ..._buildPortraitMode(appBar, mediaQuery, transactionListWidget),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startToAddNew(context),
      ),
    );
  }
}
