import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController searchCtrl = TextEditingController();
  final UserService service = UserService.instance;

  List<User> _users = [];
  List<User> results = [];
  int page = 0;
  final int pageSize = 13;

  @override
  void initState() {
    super.initState();
    // Hent alle brugere ved start
    _users = service.users;

    results = List.from(_users);
  }

  List<User> search(String query) {
    query = query.toLowerCase();

    return _users.where((u) {
      return u.phone.toLowerCase().contains(query) ||
          u.firstName.toLowerCase().contains(query) ||
          u.lastName.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query) ||
          u.city.toLowerCase().contains(query) ||
          u.address.toLowerCase().contains(query) ||
          u.zip.toLowerCase().contains(query);
    }).toList();
  }

  List<User> _pagedResults() {
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, results.length);
    return results.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find bruger")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                labelText: "Søg efter navn eller telefonnummer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  results = search(searchCtrl.text);
                  page = 0;
                });
              },
              child: const Text("Søg"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: results.isEmpty
                  ? const Text("Ingen resultater")
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: _pagedResults()
                                .map(
                                  (u) => ListTile(
                                    title: Text("${u.firstName} ${u.lastName}"),
                                    subtitle: Text("Tlf: ${u.phone}"),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: page > 0
                                  ? () => setState(() => page--)
                                  : null,
                              child: const Text("Forrige"),
                            ),
                            ElevatedButton(
                              onPressed: (page + 1) * pageSize < results.length
                                  ? () => setState(() => page++)
                                  : null,
                              child: const Text("Næste"),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
