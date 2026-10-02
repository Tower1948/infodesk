import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newsletterFreqController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _newsletterFreqController.dispose();
    super.dispose();
  }

  void _saveUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = User(
        phone: _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        address: _addressController.text,
        zip: _zipController.text,
        city: _cityController.text,
        email: _emailController.text,
        newsletterFreq: int.tryParse(_newsletterFreqController.text) ?? 0,
      );

      final userService = Provider.of<UserService>(context, listen: false);
      userService.addUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bruger oprettet')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opret bruger')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Indtast telefon' : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Fornavn'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Indtast fornavn' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Efternavn'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Indtast efternavn' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Alder'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final age = int.tryParse(value ?? '');
                  if (age == null || age <= 0) return 'Indtast gyldig alder';
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(labelText: 'Postnummer'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'By'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _newsletterFreqController,
                decoration:
                    const InputDecoration(labelText: 'Nyhedsbrev frekvens'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Gem bruger'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
