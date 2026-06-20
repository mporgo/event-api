import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _titleCtrl   = TextEditingController();
  final _descCtrl    = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  DateTime? _selectedDate;
  bool _loading = false;
  String? _error;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: kBrand)),
        child: child!,
      ),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: kBrand)),
        child: child!,
      ),
    );
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      setState(() => _error = 'Veuillez sélectionner une date.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      await api.createEvent({
        'title':       _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'date':        _selectedDate!.toUtc().toIso8601String().replaceAll(RegExp(r'\.\d+Z'), 'Z'),
        'location':    _locationCtrl.text.trim(),
        'capacity':    int.parse(_capacityCtrl.text.trim()),
      });
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = 'Erreur lors de la création.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel événement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              _field(controller: _titleCtrl, label: 'Titre *', validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 14),
              _field(controller: _descCtrl, label: 'Description', maxLines: 3),
              const SizedBox(height: 14),
              // Sélecteur de date
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1917),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF292524)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: kTextMute),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                          ? '${_selectedDate!.day.toString().padLeft(2,'0')}/${_selectedDate!.month.toString().padLeft(2,'0')}/${_selectedDate!.year}  ${_selectedDate!.hour.toString().padLeft(2,'0')}:${_selectedDate!.minute.toString().padLeft(2,'0')}'
                          : 'Sélectionner une date *',
                        style: TextStyle(
                          fontSize: 13,
                          color: _selectedDate != null ? Colors.white : kTextMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _field(controller: _locationCtrl, label: 'Lieu *', validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 14),
              _field(
                controller: _capacityCtrl,
                label: 'Capacité *',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Requis';
                  if (int.tryParse(v) == null || int.parse(v) < 1) return 'Nombre valide requis';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Créer l'événement"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
    TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(labelText: label),
    );
}
