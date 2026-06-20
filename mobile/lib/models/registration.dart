class Registration {
  final int id;
  final int eventId;
  final String firstName;
  final String lastName;
  final String email;
  final String registeredAt;

  Registration({
    required this.id,
    required this.eventId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.registeredAt,
  });

  String get fullName => '$firstName $lastName';

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
    id:           json['id'],
    eventId:      json['eventId'],
    firstName:    json['firstName'],
    lastName:     json['lastName'],
    email:        json['email'],
    registeredAt: json['registeredAt'],
  );
}
