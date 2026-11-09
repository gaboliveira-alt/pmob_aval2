import 'package:flutter/material.dart';

final class RegisterItemScreen extends StatelessWidget {
  const RegisterItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar objeto'),
      ),
      body: const Center(
        child: Text('Formulário de cadastro'),
      ),
    );
  }
}
