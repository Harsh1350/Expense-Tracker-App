import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Category { work, food, transport, luxury }

// enums allow creation of variables that accept only a fixed set of values as inputs
final Map dynamicIcon = {
  Category.work: Icons.work,
  Category.food: Icons.restaurant_outlined,
  Category.luxury: Icons.movie,
  Category.transport: Icons.airplanemode_active_outlined,
};

class Expense {
  Expense({
    required this.date,
    required this.amount,
    required this.name,
    required this.category,
  }) : expenseID = const Uuid().v4();
  // using initializing lists to assign id a value everytime 'Expense' class is called
  // without taking it as an arguement in constructor function
  final String expenseID;
  final String name;
  final DateTime date;
  final double amount;
  final Category category;
  String get formattedDate {
    return DateFormat.yMd().format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});
  ExpenseBucket.filterCategory(List<Expense> allExpenses, this.category)
      : expenses =
            allExpenses.where((expense) => expense.category == category).toList();
  final Category category;
  final List<Expense> expenses;
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
