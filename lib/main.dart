import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/create_user_page.dart'; // Skjul UserService for at undgå navnekonflikt
import 'pages/search_user_page.dart'; // Skjul UserService for at undgå navnekonflikt
import 'pages/list_users_page.dart';
// Skjul UserService for at undgå navnekonflikt
import 'pages/average_age_page.dart'; // Skjul UserService for at undgå navnekonflikt
import 'services/user_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  if (!await Permission.storage.isGranted) {
    await Permission.storage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService.instance.loadUsers();

  runApp(
    ChangeNotifierProvider<UserService>.value(
      value: UserService.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Min Infodesk',
      home:
          const HomePage(), // Start med HomePage, hvor adgangskode-dialogen er
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> _showPasswordDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    const String correctPassword = "1234"; // Hardcodet kode

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Adgangskode kræves"),
              content: TextField(
                controller: controller,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Indtast kode"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Annuller"),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text == correctPassword) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, false);
                    }
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Min InfoDesk')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _menuButton(
              context,
              icon: Icons.person_add,
              label: 'Opret bruger',
              page: const CreateUserPage(),
            ),
            _menuButton(
              context,
              icon: Icons.search,
              label: 'Find bruger',
              page: const SearchUserPage(),
            ),
            InkWell(
              onTap: () async {
                bool allowed = await _showPasswordDialog(context);
                if (allowed) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListUsersPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Forkert adgangskode")),
                  );
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, size: 48, color: Colors.blue.shade700),
                    const SizedBox(height: 12),
                    const Text('Vis alle', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            _menuButton(
              context,
              icon: Icons.calculate,
              label: 'Gennemsnits-\nalder',
              page: const AverageAgePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue.shade700),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
