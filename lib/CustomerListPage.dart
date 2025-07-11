import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cst2335_final_project/CustomerDatabase.dart';
import 'package:cst2335_final_project/CustomerRepository.dart';
import 'package:cst2335_final_project/CustomerDAO.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'CustomerItem.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  /// Part of localization
  static void setLocale(BuildContext context, Locale newLocale) async {
    CustomerListPageState? state =
    context.findAncestorStateOfType<CustomerListPageState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<CustomerListPage> createState() {
    return CustomerListPageState();
  }
}

class CustomerListPageState extends State<CustomerListPage> {
  ///initializing the repository for shared preferences
  final CustomerRepository _customerRepository = CustomerRepository();

  /// Setting the initial language to Canadian English
  var _locale = Locale("en", "CA");

  /// Variables for the text fields
  late TextEditingController _firstController;
  late TextEditingController _lastController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;

  ///variable for shared preferences
  late EncryptedSharedPreferences savedCustomer;

  /// Initializing the DAO
  late CustomerDAO DAO;

  /// Array variable for the list view
  var customer = <CustomerItem>[];

  /// Variable for what is displayed. Starts with customer input
  var _currentMode = 'inputMode';

  /// For finding the selected customer's ID
  int? selectedCustomerId;

  @override
  void initState() {
    super.initState();
    _firstController = TextEditingController();
    _lastController = TextEditingController();
    _addressController = TextEditingController();
    _birthdayController = TextEditingController();

    savedCustomer = EncryptedSharedPreferences();

    _loadData();

    $FloorCustomerDatabase
        .databaseBuilder('app_database.db')
        .build()
        .then((database) async {
      DAO = database.getDAO;

      DAO.getAllItems().then((listOfItems) {
        setState(() {
          customer.addAll(listOfItems);
        });
      });
    });
  }

  /// When called, takes selected language as argument, then changes to it
  void changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  /// Shared preferences loading into text fields
  Future<void> _loadData() async {
    final data = await _customerRepository.loadData();
    setState(() {
      _firstController.text = data['firstName']!;
      _lastController.text = data['lastName']!;
      _addressController.text = data['address']!;
      _birthdayController.text = data['birthday']!;
    });
  }

  ///Saving the shared preferences
  void _saveData() {
    _customerRepository.saveData(
      _firstController.text,
      _lastController.text,
      _addressController.text,
      _birthdayController.text,
    );
  }

  /// Takes String argument to determine what to display
  void _toggleMode(String mode) {
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      locale: _locale,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Profile Page"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _instructions(context);
              },
              child: const Text('Info'),
            ),

          ],
        ),
        body: Center(
          child: () {
            if (_currentMode == 'inputMode') {
              return _customerInput();
            } else if (_currentMode == 'updateMode') {
              return _customerUpdate();
            } else if (_currentMode == 'displayMode') {
              return _customerList();
            } else {
              return _responsiveLayout();
            }
          }(),
        ),
      ),
    );
  }

  /// Displays instructions
  _instructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'Use the text fields to input information about a customer.'
                  'All fields must be filled. On the customer list page, you may select a customer '
                  'from the list to view information, update information, or delete the customer'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// TextFields to input customer information
  Widget _customerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
            controller: _firstController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "First Name")),
        const SizedBox(height: 5),
        TextField(
            controller: _lastController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Last Name")),
        const SizedBox(height: 5),
        Row(children: [
          Flexible(
            child: TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Address")),
          ),
        ]),
        const SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              child: TextField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Birthday")),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: addCustomer,
          child: const Text("Add Customer"),
        ),
        ElevatedButton(
            onPressed: () {
              _toggleMode('displayMode');
            },
            child: const Text("Go to list"))
      ],
    );
  }

  /// ListView to show all current customers
  Widget _customerList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: customer.length,
            itemBuilder: (BuildContext context, int rowNum) {
              return GestureDetector(
                child: Row(children: [
                  Text("Customer:     ${customer[rowNum].firstName}",
                      style: const TextStyle(fontSize: 30))
                ]),
                onTap: () {
                  selectedCustomerId = customer[rowNum].id;
                  _firstController.text = customer[rowNum].firstName;
                  _lastController.text = customer[rowNum].lastName;
                  _addressController.text = customer[rowNum].address;
                  _birthdayController.text = customer[rowNum].birthday;
                  _toggleMode("responsiveMode");
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _newCustomer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
          ),
          child: const Text("New Customer"),
        ),
      ],
    );
  }

  /// Goes to customer input screen to insert a new one
  void _newCustomer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start with previous customer\'s data?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _toggleMode('inputMode');
                _loadData();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('No'),
                onPressed: () {
                  _toggleMode('inputMode');
                  _firstController.text = "";
                  _lastController.text = "";
                  _addressController.text = "";
                  _birthdayController.text = "";
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  /// Adds the customer to the database then displays the ListView
  void addCustomer() {
    if (_firstController.text.isNotEmpty &&
        _lastController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty) {
      setState(() {
        var newCustomer = CustomerItem(
            CustomerItem.ID++,
            _firstController.value.text,
            _lastController.value.text,
            _addressController.value.text,
            _birthdayController.value.text);

        customer.add(newCustomer);

        _saveData();

        DAO.insertCustomer(newCustomer);
        _firstController.text = "";
        _lastController.text = "";
        _addressController.text = "";
        _birthdayController.text = "";
        _currentMode = 'displayMode';


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer added'),
            duration: Duration(seconds: 3),
          ),
        );

      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incomplete Form'),
            content: const Text('Please fill in all fields before submitting.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// Similar to _customerInput but for established customers. Has delete button
  Widget _customerUpdate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
            controller: _firstController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "First Name")),
        const SizedBox(height: 5),
        TextField(
            controller: _lastController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Last Name")),
        const SizedBox(height: 5),
        Row(children: [
          Flexible(
            child: TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Address")),
          ),
        ]),
        const SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              child: TextField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Birthday")),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: updateCustomer,
          child: const Text("Update Customer"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed: deleteCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            child:
            const Text("Delete Customer") // Set the background color to red
        ),
      ],
    );
  }

  /// Updates the selected customer and returns to ListView
  void updateCustomer() {
    if (_firstController.text.isNotEmpty &&
        _lastController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty) {
      setState(() {
        var firstName = _firstController.text;
        var lastName = _lastController.text;
        var address = _addressController.text;
        var birthday = _birthdayController.text;
        var updatedCustomer = CustomerItem(
          selectedCustomerId!,
          firstName,
          lastName,
          address,
          birthday,
        );

        int index =
        customer.indexWhere((item) => item.id == selectedCustomerId);
        customer[index] = updatedCustomer; // Update the existing customer

        _saveData();

        DAO.updateCustomer(updatedCustomer);
        _firstController.text = "";
        _lastController.text = "";
        _addressController.text = "";
        _birthdayController.text = "";
        _currentMode = 'displayMode';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer updated'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incomplete Form'),
            content: const Text('Please fill in all fields before submitting'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// Removes customer from ListView and database
  void deleteCustomer() {
    setState(() {
      customer.removeWhere((item) => item.id == selectedCustomerId);

      // Delete the customer from the database
      var customerToDelete = CustomerItem(
        selectedCustomerId!,
        _firstController.text,
        _lastController.text,
        _addressController.text,
        _birthdayController.text,
      );
      DAO.deleteCustomer(customerToDelete);

      _firstController.text = "";
      _lastController.text = "";
      _addressController.text = "";
      _birthdayController.text = "";
      _currentMode = 'displayMode';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer deleted'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  /// If in landscape mode on tablet, displays both the ListView and _customerUpdate simultaneously
  Widget _responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) //landscape mode
        {
      return Row(children: [
        Expanded(flex: 1, child: _customerList()),
        Expanded(flex: 1, child: _customerUpdate())
      ]);
    } else //portrait mode
      _toggleMode('updateMode');
    return _customerUpdate();
  }
}