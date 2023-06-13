import 'package:expense_app/class/expense_class.dart';
import 'package:flutter/material.dart';

class ExpenseBlock extends StatelessWidget {
  const ExpenseBlock(this.expense, {super.key});
  final Expense expense;
  @override
  Widget build(context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            expense.name,
            style: Theme.of(context).textTheme.titleLarge,
            // using the theme that we pre-defined for titleLarge in main.dart file 
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text('₹${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    dynamicIcon[expense.category],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(expense.formattedDate),
                ],
              )
            ],
          ),
          // doing this to show a dollar sign before amount because dollar sign is
          // a pre-defined operator in flutter
        ],
      ),
    ));
  }
}
