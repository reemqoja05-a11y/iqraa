/// A reading group or challenge created by a user.
class ReadingGroup {
  final String id;
  final String name;
  final String description;
  final String joinCode;
  final String coverUrl;
  final String bookTitle;
  final String bookCoverUrl;
  final int totalPages;
  final int daysDuration;
  final GroupPrivacy privacy;
  final double collectiveProgress; // 0-100
  final int memberCount;
  final DateTime createdAt;
  final bool isChallenge;

  const ReadingGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.joinCode,
    required this.coverUrl,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.totalPages,
    required this.daysDuration,
    required this.privacy,
    this.collectiveProgress = 0,
    required this.memberCount,
    required this.createdAt,
    this.isChallenge = false,
  });
}

enum GroupPrivacy { private, public }

extension GroupPrivacyExtension on GroupPrivacy {
  String get label {
    switch (this) {
      case GroupPrivacy.private:
        return 'مجموعة خاصة (برمز دعوة فقط)';
      case GroupPrivacy.public:
        return 'تحدي عام مفتوح لجميع القرّاء';
    }
  }

  String get detail {
    switch (this) {
      case GroupPrivacy.private:
        return 'الانضمام برمز أو رابط دعوة حصري من المشرف فقط دون ظهور في الدليل العام.';
      case GroupPrivacy.public:
        return 'متاح لجميع أفراد مجتمع القراءة للمشاركة والتنافس في جداول الإنجاز.';
    }
  }
}

/// A member of a reading group.
class GroupMember {
  final String id;
  final String name;
  final String role; // e.g. "منشئ المجموعة", "قارئ", "قارئة"
  final String bio;
  final String avatarUrl;
  final int progressPercent;
  final bool isCurrentUser;

  const GroupMember({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.avatarUrl,
    required this.progressPercent,
    this.isCurrentUser = false,
  });
}

/// A vote cast by a member on a group rescue challenge.
class GroupVote {
  final String memberId;
  final bool agree; // true = extend, false = keep

  const GroupVote({required this.memberId, required this.agree});
}
