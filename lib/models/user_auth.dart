import 'package:hive/hive.dart';

part 'user_auth.g.dart';

@HiveType(typeId: 10)
class UserAuth extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String fullName;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime lastLoginAt;

  @HiveField(6)
  bool isLoggedIn;

  @HiveField(7)
  String? profilePicturePath;

  UserAuth({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.createdAt,
    required this.lastLoginAt,
    this.isLoggedIn = false,
    this.profilePicturePath,
  });

  factory UserAuth.create({
    required String email,
    required String password,
    required String fullName,
    String? profilePicturePath,
  }) {
    final now = DateTime.now();
    return UserAuth(
      id: now.millisecondsSinceEpoch.toString(),
      email: email.toLowerCase().trim(),
      password: password,
      fullName: fullName.trim(),
      createdAt: now,
      lastLoginAt: now,
      isLoggedIn: true,
      profilePicturePath: profilePicturePath,
    );
  }

  /// Validate email format using regex
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    // At least 6 characters, contains at least one letter and one number
    if (password.length < 6) return false;
    
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    
    return hasLetter && hasNumber;
  }

  /// Validate full name
  static bool isValidFullName(String name) {
    return name.trim().length >= 2;
  }

  /// Update login status
  void updateLoginStatus(bool isLoggedIn) {
    this.isLoggedIn = isLoggedIn;
    if (isLoggedIn) {
      lastLoginAt = DateTime.now();
    }
  }

  /// Get display name (first name)
  String get displayName {
    final names = fullName.split(' ');
    return names.isNotEmpty ? names.first : fullName;
  }

  /// Get initials for avatar
  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  @override
  String toString() {
    return 'UserAuth(id: $id, fullName: $fullName, email: $email, isLoggedIn: $isLoggedIn)';
  }
}
