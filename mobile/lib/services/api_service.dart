import 'package:dio/dio.dart';
import '../models/event.dart';
import '../models/registration.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
  // Pour device physique : remplace par l'IP locale ex: http://192.168.1.x:8000/api

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // ── Événements ─────────────────────────────────────────

  Future<List<Event>> getEvents() async {
    final res = await _dio.get('/events');
    return (res.data as List).map((e) => Event.fromJson(e)).toList();
  }

  Future<Event> getEvent(int id) async {
    final res = await _dio.get('/events/$id');
    return Event.fromJson(res.data);
  }

  Future<Event> createEvent(Map<String, dynamic> data) async {
    final res = await _dio.post('/events', data: data);
    return Event.fromJson(res.data);
  }

  Future<void> deleteEvent(int id) async {
    await _dio.delete('/events/$id');
  }

  // ── Inscriptions ────────────────────────────────────────

  Future<Registration> register(int eventId, Map<String, dynamic> data) async {
    final res = await _dio.post('/events/$eventId/registrations', data: data);
    return Registration.fromJson(res.data);
  }

  Future<List<Registration>> getRegistrations(int eventId) async {
    final res = await _dio.get('/events/$eventId/registrations');
    return (res.data as List).map((r) => Registration.fromJson(r)).toList();
  }
}

// Instance globale
final api = ApiService();
