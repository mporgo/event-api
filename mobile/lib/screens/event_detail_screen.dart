import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../models/registration.dart';
import '../services/api_service.dart';
import 'register_sheet.dart';
import '../theme.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? _event;
  List<Registration> _registrations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        api.getEvent(widget.eventId),
        api.getRegistrations(widget.eventId),
      ]);
      setState(() {
        _event         = results[0] as Event;
        _registrations = results[1] as List<Registration>;
        _loading       = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _showRegisterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RegisterSheet(
        event: _event!,
        onSuccess: (reg) {
          setState(() {
            _registrations.insert(0, reg);
            _event = Event(
              id:              _event!.id,
              title:           _event!.title,
              description:     _event!.description,
              date:            _event!.date,
              location:        _event!.location,
              capacity:        _event!.capacity,
              registeredCount: _event!.registeredCount + 1,
              createdAt:       _event!.createdAt,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Inscription de ${reg.fullName} confirmée !'),
              backgroundColor: Colors.green.shade700,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kBrand)),
      );
    }

    if (_event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Événement introuvable.', style: TextStyle(color: kTextMute))),
      );
    }

    final e    = _event!;
    final date = DateTime.tryParse(e.date);
    final dateStr = date != null
      ? DateFormat('EEEE dd MMMM yyyy • HH:mm', 'fr_FR').format(date.toLocal())
      : e.date;

    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: e.isFull ? Colors.red.withOpacity(0.15) : kBrand.withOpacity(0.15),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                e.isFull ? '🔒 Complet' : '✅ Inscriptions ouvertes',
                style: TextStyle(
                  color: e.isFull ? Colors.redAccent : kBrand,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Titre
            Text(e.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            if (e.description != null) ...[
              const SizedBox(height: 10),
              Text(e.description!, style: const TextStyle(color: kTextMute, fontSize: 13, height: 1.6)),
            ],
            const SizedBox(height: 16),
            // Infos
            _InfoRow(icon: Icons.calendar_today_outlined, text: dateStr.capitalize()),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.location_on_outlined, text: e.location),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.people_outline, text: '${e.registeredCount} / ${e.capacity} inscrits'),
            const SizedBox(height: 14),
            // Barre capacité
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: e.fillRate.clamp(0.0, 1.0),
                backgroundColor: kBorder,
                color: e.isFull ? Colors.redAccent : kBrand,
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 24),
            // Bouton inscription
            ElevatedButton(
              onPressed: e.isFull ? null : _showRegisterSheet,
              child: Text(e.isFull ? 'Événement complet' : "S'inscrire"),
            ),
            // Liste inscrits
            if (_registrations.isNotEmpty) ...[
              const SizedBox(height: 28),
              Text(
                'Participants (${_registrations.length})',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._registrations.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: kBrand.withOpacity(0.15),
                      child: Text(
                        r.firstName[0].toUpperCase(),
                        style: const TextStyle(color: kBrand, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.fullName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                          Text(r.email, style: const TextStyle(color: kTextMute, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 15, color: kBrand),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(color: kTextMute, fontSize: 13))),
    ],
  );
}

extension StringExt on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
