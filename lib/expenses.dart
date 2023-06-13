import 'package:expense_app/models/input_expense.dart';
import 'package:expense_app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/class/expense_class.dart';
import 'package:expense_app/models/expense_list.dart';

List<Expense> inputList1 = [];

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});
  @override
  State<ExpenseTracker> createState() {
    return _ExpenseTrackerState();
  }
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  List<Expense> addedExpenses = [
    Expense(
        date: DateTime.now(),
        amount: 69.69,
        name: 'First Expense',
        category: Category.luxury)
  ];
  void addExpense(Expense expense) {
    setState(() {
      addedExpenses.add(expense);
    });
  }

  void removeOnSwipe(Expense expense) {
    final expenseIndex = addedExpenses.indexOf(expense);
    // noting down the index of expense that will be removed by the user so that we can add it
    // again in case the user presses undo.
    setState(() {
      addedExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text(
          'Expense deleted',
        ),
        // this allows us to show a pop up that will appear at the bottom of the screen after user
        // swipes the expense to delete it and will show an alert that expense was deleted
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              addedExpenses.insert(expenseIndex, expense);
            });
          },
          // adding the undo button with the function of inserting the previously deleted expense
          // into the addedExpenses using insert function as we want to place that expense back
          // at its original index in list
        ),
      ),
    );
  }

  void _onPressingAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      // ensuring that the widgets appear at the top and the modal sheet occupies full screen
      useSafeArea: true,
      // ensuring that the modalbottomsheet doesnt get overlapped by camera module or other 
      // physical attributes of device.
      context: context,
      builder: (ctx) => UserInput(addExpense),
    );
    // showMOdalBttomSheet allows us to create a screen that is only meant for making
    // a specific change and then reverts back to original screen when we tap anywhere
    // outside the frame
  }

  @override
  Widget build(context) {
    final widthofScreen = MediaQuery.of(context).size.width;
    Widget mainScreen = Column(
      children: [
        Expanded(
          // using expanded widget because we are passing ExpensesList which is a
          // column in its elf in the column widget in this build method
          child: ExpensesList(
            expenses: addedExpenses,
            removeOnSwipe: removeOnSwipe,
          ),
        ),
      ],
    );
    setState(() {
      if (addedExpenses.isEmpty) {
        mainScreen = const Center(
          child: Text('No expenses found.Try adding some!'),
        );
      }
      // using if statement in setState to check whether list of expenses is empty in order to
      // notify user that there are currently no expenses registered.
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          // we can use appBar feature of Scaffold to add the top bar which would contain
          // button for adding new expenses to the list.
          IconButton(
            onPressed: _onPressingAdd,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
        title: const Text(
          'Expense Tracker',
        ),
      ),
      body: widthofScreen < 600
          ? Column(children: [
              Chart(expenses: addedExpenses),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: mainScreen,
              ),
            ])
          : Row(
              children: [
                Expanded(
                  // here we wrap chart in expanded widget because chart is set to occupy maximum 
                  // horizontal space on screen whereas row also does that, to make this work 
                  // expanded widget is necessary.
                  child: Chart(expenses: addedExpenses),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: mainScreen,
                ),
              ],
            ),
            // when the phone is in portrait mode width is below 600(upon observation) and greater 
            // than 600 when in landscape mode so using that as a condition for setting responsive 
            // UIs accordingly
    );
  }
}
