// lib/screens/register_sheet.dart
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/registration.dart';
import '../services/api_service.dart';
import '../theme.dart';

class RegisterSheet extends StatefulWidget {
  final Event event;
  final Function(Registration) onSuccess;

  const RegisterSheet({super.key, required this.event, required this.onSuccess});

  @override
  State<RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends State<RegisterSheet> {
  final _firstCtrl = TextEditingController();
  final _lastCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (_firstCtrl.text.isEmpty || _lastCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      setState(() => _error = 'Tous les champs sont obligatoires.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      final reg = await api.register(widget.event.id, {
        'firstName': _firstCtrl.text.trim(),
        'lastName':  _lastCtrl.text.trim(),
        'email':     _emailCtrl.text.trim(),
      });
      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess(reg);
      }
    } on Exception catch (e) {
      setState(() => _error = e.toString().contains('DUPLICATE')
        ? 'Cet email est déjà inscrit à cet événement.'
        : 'Une erreur est survenue.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(99)),
            ),
          ),
          const SizedBox(height: 16),
          const Text("S'inscrire", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(widget.event.title, style: const TextStyle(color: kTextMute, fontSize: 12), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
          ],
          Row(children: [
            Expanded(child: _input(_firstCtrl, 'Prénom')),
            const SizedBox(width: 10),
            Expanded(child: _input(_lastCtrl, 'Nom')),
          ]),
          const SizedBox(height: 12),
          _input(_emailCtrl, 'Email', type: TextInputType.emailAddress),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("Confirmer l'inscription"),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String hint, {TextInputType type = TextInputType.text}) =>
    TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(hintText: hint),
    );
}
