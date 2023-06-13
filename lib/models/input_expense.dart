import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/class/expense_class.dart';

List<Expense> inputExpenses = [];

class UserInput extends StatefulWidget {
  const UserInput(this.onAddExpense, {super.key});
  final Function onAddExpense;
  @override
  State<UserInput> createState() {
    return _UserInputState();
  }
}

class _UserInputState extends State<UserInput> {
  final storeTitle = TextEditingController();
  final storeAmount = TextEditingController();
  // initializing a variable as function of 'texteditingcontroller' which is a function
  // that automatically store input data
  Category selectedCategory = Category.transport;
  // initializing the default category as transport to display initially or by default on
  // drop down menu.
  // initializing the list which will store expenses added by user for passing to display on
  // first screen.
  DateTime? storeDate;
  void datePicker() async {
    final present = DateTime.now();
    // records the present time when function is executed
    final end = DateTime(present.year + 1, present.month, present.day);
    final past = DateTime(present.year - 1, present.month, present.day);
    final chosenDate = await showDatePicker(
      //  allows us to pick date but requires start date, default date and max date as
      //  arguements and a context parameter
      context: context,
      initialDate: present,
      firstDate: past,
      lastDate: end,
    );
    // as we used 'async' and 'await' in our function, the code below this in this function
    // will only be executed once the showDatePicker is called.
    setState(() {
      storeDate = chosenDate;
    });
  }

  void submitExpense() {
    final enteredAmount = double.tryParse(storeAmount.text);
    final invalidAmount = enteredAmount == null || enteredAmount <= 0;
    if (storeAmount.text.trim().isEmpty || invalidAmount || storeDate == null) {
      // 'trim' removes all the blank spaces between characters in a string and 'isEmpty' checks
      // if the string is empty.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Invalid Input',
          ),
          content: const Text(
            'Please make sure you have entered all the details in correct format',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // closing the window on pressing this
              },
              child: const Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          date: storeDate!,
          amount: enteredAmount,
          name: storeTitle.text,
          category: selectedCategory),
    );
    Navigator.pop(context);
    // closing the modal sheet after user presses save button
  }

  @override
  void dispose() {
    storeTitle.dispose();
    storeAmount.dispose();
    super.dispose();
  }
  // it is necessary to dispose of the 'TextEditingController' as it is in dynamically
  // created memory space

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      // layoutBuilder allows us to access the space constraints of widget and use them to make
      // custom layouts for different orientations
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        // storing maxWidth constraint of our screen's orientation
        return SizedBox(
          height: double.infinity,
          // making sure that the modelsheet occupies full screen by default
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            // widget enables us to  take a text input string
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                            controller: storeTitle,
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: storeAmount,
                            decoration: const InputDecoration(
                              prefixText: '₹',
                              label: Text(
                                'Amount',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      // widget enables us to  take a text input string
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      controller: storeTitle,
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: selectedCategory,
                          // this value refers to the value that should be displayed
                          items: Category.values
                              // dropdownbutton will accept the items in enum category as arguements and
                              // 'values' and return them as string name.
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  // map will return the selected category when it is selected by user
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            // this value refers to the value that user will select
                            if (value == null) {
                              // is user doesnt selected any category this function will return nothing
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        Text(
                          storeDate == null
                              ? 'Date not selected'
                              : DateFormat.yMd().format(storeDate!),
                          // storeDate can be a null variable but to assure that it won't be for it
                          // to be accepted as an arguement in Text, we use exclaimation
                        ),
                        IconButton(
                          onPressed: datePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          // it is necessary to wrap both text field and the date input in Expanded
                          // as both of them used at a time would cause issues in space being
                          // taken by both of them so ensuring that they take as much space as
                          // possible within the screen but no more than the screen is necessary
                          child: TextField(
                            controller: storeAmount,
                            decoration: const InputDecoration(
                              prefixText: '₹',
                              label: Text(
                                'Amount',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                storeDate == null
                                    ? 'Date not selected'
                                    : DateFormat.yMd().format(storeDate!),
                                // storeDate can be a null variable but to assure that it won't be for it
                                // to be accepted as an arguement in Text, we use exclaimation
                              ),
                              IconButton(
                                onPressed: datePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // using this to pop out of this UserInput widget when cancel button is pressed
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: submitExpense,
                          child: const Text(
                            'Save Expense',
                            style: TextStyle(
                                color: Color.fromARGB(255, 197, 32, 32),),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: selectedCategory,
                          // this value refers to the value that should be displayed
                          items: Category.values
                              // dropdownbutton will accept the items in enum category as arguements and
                              // 'values' and return them as string name.
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  // map will return the selected category when it is selected by user
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            // this value refers to the value that user will select
                            if (value == null) {
                              // is user doesnt selected any category this function will return nothing
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // using this to pop out of this UserInput widget when cancel button is pressed
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: submitExpense,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
