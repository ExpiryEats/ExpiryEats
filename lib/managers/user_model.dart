class User {
  final String firstName;
  final String lastName;
  final String email;
  final String householdId;
  final List<String> dietaryRequirements;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.householdId,
    required this.dietaryRequirements,
  });

  // Add the copyWith method
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? householdId,
    List<String>? dietaryRequirements,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      householdId: householdId ?? this.householdId,
      dietaryRequirements: dietaryRequirements ?? this.dietaryRequirements,
    );
  }
}