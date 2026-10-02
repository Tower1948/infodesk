import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:infodesk/models/user.dart';

class UserService extends ChangeNotifier {
  static final UserService instance = UserService._internal();
  UserService._internal();

  List<User> _users = [];
  List<User> get users => List.unmodifiable(_users);

  // Hent lokal fil til gemning og indlæsning
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/users_data.json");
  }

  // Indlæs users fra lokal fil, eller fallback til assets
  Future<void> loadUsers() async {
    try {
      final localFile = await _getLocalFile();

      String jsonString;
      if (await localFile.exists()) {
        jsonString = await localFile.readAsString();
        print('Indlæste data fra lokal lagring');
      } else {
        jsonString = await rootBundle.loadString('assets/users.json');
        print('Indlæste data fra assets (første kørsel)');
      }

      final List<dynamic> data = jsonDecode(jsonString);
      _users = data.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print("Fejl ved indlæsning: $e");
      _users = [];
      notifyListeners();
    }
  }

  // Gem users til lokal fil
  Future<void> saveUsers() async {
    try {
      final file = await _getLocalFile();
      final jsonString = jsonEncode(_users.map((u) => u.toJson()).toList());
      await file.writeAsString(jsonString);
      print('Data gemt lokalt');
    } catch (e) {
      print("Fejl ved gem: $e");
    }
  }

  // CRUD-funktioner

  void addUser(User user) {
    _users.add(user);
    saveUsers();
    notifyListeners();
  }

  void removeUser(String phone) {
    _users.removeWhere((u) => u.phone == phone);
    saveUsers();
    notifyListeners();
  }

  void updateUser(String phone, User newUser) {
    final index = _users.indexWhere((u) => u.phone == phone);
    if (index != -1) {
      _users[index] = newUser;
      saveUsers();
      notifyListeners();
    }
  }

  User? getUser(String phone) {
    try {
      return _users.firstWhere((u) => u.phone == phone);
    } catch (e) {
      return null;
    }
  }

  double averageAge() {
    if (_users.isEmpty) return 0;
    final totalAge = _users.fold<int>(0, (sum, user) => sum + user.age);
    return totalAge / _users.length;
  }

  List<User> search(String query) {
    if (query.isEmpty) return _users;
    final lowerQuery = query.toLowerCase();
    return _users.where((u) {
      return u.phone.toLowerCase().contains(lowerQuery) ||
          u.firstName.toLowerCase().contains(lowerQuery) ||
          u.lastName.toLowerCase().contains(lowerQuery) ||
          u.email.toLowerCase().contains(lowerQuery) ||
          u.city.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
