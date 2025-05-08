class CacheManager {
  // User data
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? householdId;
  final List<String> dietaryRequirements;

  // Reference data
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> storageTypes;
  final List<Map<String, dynamic>> dietaryRestrictionTypes;

  CacheManager({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.householdId,
    this.dietaryRequirements = const [],
    this.categories = const [],
    this.storageTypes = const [],
    this.dietaryRestrictionTypes = const [],
  });

  CacheManager copyWith({
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? householdId,
    List<String>? dietaryRequirements,
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? storageTypes,
    List<Map<String, dynamic>>? dietaryRestrictionTypes,
  }) {
    return CacheManager(
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        householdId: householdId ?? this.householdId,
        dietaryRequirements: dietaryRequirements ?? this.dietaryRequirements,
        categories: categories ?? this.categories,
        storageTypes: storageTypes ?? this.storageTypes,
        dietaryRestrictionTypes:
            dietaryRestrictionTypes ?? this.dietaryRestrictionTypes);
  }
}
