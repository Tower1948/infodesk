import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AverageAgePage extends StatelessWidget {
  const AverageAgePage({super.key});

  @override
  Widget build(BuildContext context) {
   final service = UserService.instance;

    final avg = service.averageAge();

    return Scaffold(
      appBar: AppBar(title: const Text("Gennemsnitsalder")),
      body: Center(
        child: Text(
          avg == 0
              ? "Ingen brugere oprettet endnu"
              : "Gennemsnitsalder: ${avg.toStringAsFixed(1)} år",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
