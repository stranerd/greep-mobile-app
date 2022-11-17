import 'package:greep/application/response.dart';
import 'package:greep/domain/customer/customer.dart';
import 'package:greep/domain/customer/customer_client.dart';

class CustomerService {
  final CustomerClient _customerClient;

  CustomerService(this._customerClient);

  Future<ResponseEntity<List<Customer>>> getCustomers()async {
    return await _customerClient.getCustomers();
  }



}
