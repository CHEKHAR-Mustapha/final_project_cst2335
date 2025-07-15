import 'package:floor/floor.dart';
import 'package:cst2335_final_project/CustomerItem.dart';

@dao
abstract class CustomerDAO {

  @insert
  Future<void> insertCustomer(CustomerItem item);

  @delete
  Future<int> deleteCustomer(CustomerItem item);

  @Query('SELECT * FROM CustomerItem')
  Future <List<CustomerItem>> getAllItems();

  @update
  Future<int> updateCustomer(CustomerItem item);
}