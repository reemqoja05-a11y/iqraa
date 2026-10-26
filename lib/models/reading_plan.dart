/// A reading plan created for a single book.
class ReadingPlan {
  final String id;
  final String bookId;
  final DateTime startDate;
  DateTime targetDate;
  final int targetPages;
  int completedPages;
  DateTime? lastCompletedDate;
  int consecutiveDays;
  bool isActive;

  ReadingPlan({
    required this.id,
    required this.bookId,
    required this.startDate,
    required this.targetDate,
    required this.targetPages,
    this.completedPages = 0,
    this.lastCompletedDate,
    this.consecutiveDays = 0,
    this.isActive = true,
  });

  /// Number of days remaining until the target date (inclusive of today).
  int get daysRemaining {
    final today = DateTime.now();
    final diff = targetDate.difference(today).inDays;
    return diff.clamp(0, diff.isNegative ? 0 : diff);
  }

  /// Pages remaining to reach the target.
  int get pagesRemaining => (targetPages - completedPages).clamp(0, targetPages);

  /// Daily reading target calculated from remaining pages and remaining days.
  int get dailyTarget {
    final days = daysRemaining;
    if (days <= 0) return 0;
    return (pagesRemaining / days).ceil();
  }

  /// Progress percentage (0-100).
  double get progressPercent {
    if (targetPages <= 0) return 0;
    return (completedPages / targetPages) * 100;
  }

  /// Whether the plan has been fully completed.
  bool get isCompleted => completedPages >= targetPages;

  /// Whether the plan is overdue (target date passed and not completed).
  bool get isOverdue {
    final today = DateTime.now();
    return !isCompleted && today.isAfter(targetDate);
  }

  ReadingPlan copyWith({
    String? id,
    String? bookId,
    DateTime? startDate,
    DateTime? targetDate,
    int? targetPages,
    int? completedPages,
    DateTime? lastCompletedDate,
    int? consecutiveDays,
    bool? isActive,
  }) {
    return ReadingPlan(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      targetPages: targetPages ?? this.targetPages,
      completedPages: completedPages ?? this.completedPages,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ReadingRecord {
  final String id;
  final String planId;
  final DateTime date;
  final int pagesRead;

  const ReadingRecord({
    required this.id,
    required this.planId,
    required this.date,
    required this.pagesRead,
  });
}
