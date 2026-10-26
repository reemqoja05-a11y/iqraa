import 'package:flutter/material.dart';

import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import 'book_cover.dart';

/// A group member row with avatar, name, role and progress bar.
class GroupMemberTile extends StatelessWidget {
  final GroupMember member;

  const GroupMemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BookCover(
            imageUrl: member.avatarUrl,
            width: 44,
            height: 44,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          member.role,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${member.progressPercent}%',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: member.progressPercent / 100,
                  minHeight: 4,
                  backgroundColor: AppColors.secondaryContainer,
                  valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
