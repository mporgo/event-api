import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../theme.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<Event> _events = [];
  List<Event> _filtered = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final events = await api.getEvents();
      setState(() { _events = events; _filtered = events; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _search(String q) {
    setState(() {
      _filtered = _events.where((e) =>
        e.title.toLowerCase().contains(q.toLowerCase()) ||
        e.location.toLowerCase().contains(q.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: kBrand,
            onPressed: () => context.push('/events/new').then((_) => _load()),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kBrand,
        onRefresh: _load,
        child: _loading
          ? const Center(child: CircularProgressIndicator(color: kBrand))
          : Column(
              children: [
                // Recherche
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _search,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search, color: kTextMute, size: 20),
                    ),
                  ),
                ),
                // Liste
                Expanded(
                  child: _filtered.isEmpty
                    ? const Center(
                        child: Text('Aucun événement.', style: TextStyle(color: kTextMute)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => _EventCard(
                          event: _filtered[i],
                          onTap: () => context.push('/events/${_filtered[i].id}').then((_) => _load()),
                        ),
                      ),
                ),
              ],
            ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(event.date);
    final dateStr = date != null
      ? DateFormat('dd MMM yyyy • HH:mm', 'fr_FR').format(date.toLocal())
      : event.date;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge + compteur
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: event.isFull
                      ? Colors.red.withOpacity(0.15)
                      : kBrand.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    event.isFull ? 'Complet' : 'Places disponibles',
                    style: TextStyle(
                      fontSize: 11,
                      color: event.isFull ? Colors.redAccent : kBrand,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${event.registeredCount}/${event.capacity}',
                  style: const TextStyle(fontSize: 11, color: kTextMute),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Titre
            Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Métadonnées
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: kBrand),
              const SizedBox(width: 5),
              Text(dateStr, style: const TextStyle(fontSize: 12, color: kTextMute)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: kBrand),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(fontSize: 12, color: kTextMute),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: event.fillRate.clamp(0.0, 1.0),
                backgroundColor: kBorder,
                color: event.isFull ? Colors.redAccent : kBrand,
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
