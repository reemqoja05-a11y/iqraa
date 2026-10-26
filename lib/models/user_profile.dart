/// The mock user profile displayed on the Settings & Profile screen.
class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime memberSince;
  final int booksCompleted;
  final int commitmentDays;
  final int totalPagesRead;
  final String appVersion;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.memberSince,
    required this.booksCompleted,
    required this.commitmentDays,
    required this.totalPagesRead,
    this.appVersion = '1.0.0',
  });
}
