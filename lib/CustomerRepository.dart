import 'dart:async';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomerRepository {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> saveData(String firstName, String lastName, String address, String birthday) async {
    await _prefs.setString('firstName', firstName);
    await _prefs.setString('lastName', lastName);
    await _prefs.setString('address', address);
    await _prefs.setString('birthday', birthday);
  }

  Future<Map<String, String>> loadData() async {
    String firstName = await _prefs.getString('firstName') ?? "";
    String lastName = await _prefs.getString('lastName') ?? "";
    String address = await _prefs.getString('address') ?? "";
    String birthday = await _prefs.getString('birthday') ?? "";
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday,
    };
  }
}