class Event {
  final int id;
  final String title;
  final String? description;
  final String date;
  final String location;
  final int capacity;
  final int registeredCount;
  final String createdAt;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.location,
    required this.capacity,
    this.registeredCount = 0,
    required this.createdAt,
  });

  bool get isFull => registeredCount >= capacity;
  double get fillRate => registeredCount / capacity;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id:              json['id'],
    title:           json['title'],
    description:     json['description'],
    date:            json['date'],
    location:        json['location'],
    capacity:        json['capacity'],
    registeredCount: json['registeredCount'] ?? 0,
    createdAt:       json['createdAt'] ?? '',
  );
}
