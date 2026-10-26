import 'package:flutter/material.dart';

/// A reading achievement badge.
class Achievement {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color badgeColor;
  bool unlocked;
  final DateTime? unlockedAt;
  final String? certificateBook;

  Achievement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badgeColor,
    this.unlocked = false,
    this.unlockedAt,
    this.certificateBook,
  });
}

/// Simple stats derived from local reading data.
class ReadingStats {
  final int booksCompleted;
  final int totalPagesRead;
  final int commitmentDays;
  final int longestStreak;
  final int currentLevel;
  final double commitmentPercent;

  const ReadingStats({
    required this.booksCompleted,
    required this.totalPagesRead,
    required this.commitmentDays,
    required this.longestStreak,
    required this.currentLevel,
    required this.commitmentPercent,
  });
}
