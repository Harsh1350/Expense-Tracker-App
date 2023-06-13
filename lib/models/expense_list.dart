import 'package:expense_app/class/expense_class.dart';
import 'package:expense_app/models/expense_block.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.removeOnSwipe});
  final List<Expense> expenses;
  final Function(Expense expense) removeOnSwipe;
  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      // using ListView.builder because there can be many expense entries and many things
      // that can be displayed but aren't required at all times so Column will go on
      // processing them behind the scenes everytime its called that can lead to unnecessary
      // processing. builder function is necessary to enable this instantaneous and dynamic
      // feature.
      itemBuilder: (context, index) => Dismissible(
        // using Dismissible feature so that user may delete the expense when he drags and swipes
        // it
        key: ValueKey(expenses[index]),
        // this widget requires a key so that each call can be uniquely identifiable and correct
        // data can be disposed
        onDismissed: (direction) => removeOnSwipe(
          expenses[index],
        ),  
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.9),
        ),
        // using container because background feature only accepts widgets as arguements. using
        // background for making a red background for whenever user swipes the expense card 
        // that will cause it get deleted
        child: ExpenseBlock(
          expenses[index],
        ),
      ),
    );
  }
}
