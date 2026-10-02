import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
//import '../models/user.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final users = userService.users;

    return Scaffold(
      appBar: AppBar(title: const Text('Alle brugere')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text('${user.firstName} ${user.lastName} (${user.phone})'),
            subtitle: Text(user.email),
            // Tilføj evt. slet-knap eller andet her
          );
        },
      ),
    );
  }
}
