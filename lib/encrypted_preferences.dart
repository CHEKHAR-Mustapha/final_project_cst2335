import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

final EncryptedSharedPreferences encryptedPreferences = EncryptedSharedPreferences();

class EncryptedPreferences {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  static const String _departureCityKey = 'departureCity';
  static const String _arrivalCityKey = 'arrivalCity';

  Future<void> saveLastDepartureCity(String city) async {
    await _prefs.setString(_departureCityKey, city);
  }

  Future<void> saveLastArrivalCity(String city) async {
    await _prefs.setString(_arrivalCityKey, city);
  }

  Future<String?> getLastDepartureCity() async {
    return await _prefs.getString(_departureCityKey);
  }

  Future<String?> getLastArrivalCity() async {
    return await _prefs.getString(_arrivalCityKey);
  }
}