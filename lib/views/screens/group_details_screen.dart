import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/group.dart';
import '../../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Group Details screen (Screen 9): progress, discussion and members tabs.
class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  int _tabIndex = 0; // 0 progress, 1 discussion, 2 members
  final _chatController = TextEditingController();
  bool _votedAgree = false;

  ReadingGroup? get _group {
    final groups = appController.groups;
    return groups.isEmpty ? null : groups.first;
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _switchTab(int index) => setState(() => _tabIndex = index);

  void _castVote(bool agree) {
    final group = _group;
    if (group == null) return;
    setState(() => _votedAgree = agree);
    appController.castGroupVote(group.id, agree);
  }

  void _sendMessage() {
    appController.sendGroupMessage(_chatController.text);
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final group = _group;
        if (group == null) {
          return const Scaffold(body: Center(child: Text('لا توجد مجموعة')));
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('تفاصيل المجموعة'),
              actions: [
                _NavIcon(Icons.share, onTap: () {}),
                const SizedBox(width: 8),
                _NavIcon(Icons.more_vert, onTap: () {}),
              ],
            ),
            body: Column(
              children: [
                // Group summary hero card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E4D3),
                          border: Border.all(color: const Color(0xFFCDAA85)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8EC),
                                    border: Border.all(
                                        color: const Color(0xFFD9A441)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('#IQRA-8429',
                                          style: TextStyle(
                                            color: Color(0xFF4F5D2F),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.group,
                                        size: 16, color: Color(0xFF4F5D2F)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${group.memberCount} عضواً',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 13,
                                      )),
                                    ],
                                  ),
                                const Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {},
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF8EC),
                                        border: Border.all(
                                            color: const Color(0xFFCDAA85)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.person_add,
                                              size: 16, color: Color(0xFF6B4630)),
                                          SizedBox(width: 4),
                                          Text('دعوة',
                                              style: TextStyle(
                                                color: Color(0xFF6B4630),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              group.name,
                              style: const TextStyle(
                                color: Color(0xFF3E2A1E),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              group.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 3-tab segmented switcher
                      _SegmentedRow(
                        tabs: const [
                          TabItem(icon: Icons.auto_stories, label: 'التقدم'),
                          TabItem(icon: Icons.chat_bubble_outline, label: 'النقاش'),
                          TabItem(icon: Icons.group, label: 'الأعضاء'),
                        ],
                        active: _tabIndex,
                        onTap: _switchTab,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: _tabIndex == 0
                      ? _ProgressTab(group: group)
                      : _tabIndex == 1
                          ? _DiscussionTab()
                          : _MembersTab(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ProgressTab({required ReadingGroup group}) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        // Current book & collective progress
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    BookCover(
                      imageUrl: group.bookCoverUrl,
                      width: 72,
                      height: 100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الكتاب المختار حالياً',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            group.bookTitle,
                            style: const TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'عبد الرحمن بن محمد ابن خلدون',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Color(0xFF6B4630)),
                              const SizedBox(width: 6),
                              Text(
                                'الأسبوع 2 • ص 120 إلى 240',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E4D3),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.auto_stories,
                          size: 24, color: Color(0xFF6B4630)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Color(0xFFF1E4D3), height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'نسبة الإنجاز الكلية للمجموعة',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '62% مكتمل',
                      style: TextStyle(
                        color: Color(0xFF6B4630),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.62,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1E4D3),
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFF4F5D2F)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('👏', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '14 من 18 عضواً سجلوا قراءتهم اليوم',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Rescue challenge card
        Card(
          color: const Color(0xFFFFF8EC),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E4D3),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.handshake,
                          size: 22, color: Color(0xFF6B4630)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'تحدي الرفاق 🤝',
                                style: TextStyle(
                                  color: Color(0xFF3E2A1E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFFCDAA85)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'اقتراح مرن',
                                  style: TextStyle(
                                    color: Color(0xFF6B4630),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'تخفيف الورد اليومي ومواكبة الجميع بكل أريحية ودون استعجال.',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCDAA85)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'تمديد الختم 5 أيام لتدارك الفصول',
                              style: const TextStyle(
                                color: Color(0xFF3E2A1E),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text(
                            '11 صوت مع',
                            style: TextStyle(
                              color: Color(0xFF4F5D2F),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: AppButton(
                                text:
                                    _votedAgree ? 'تم التصويت (12)' : 'موافق (11)',
                                icon: Icon(
                                  _votedAgree
                                      ? Icons.check
                                      : Icons.thumb_up,
                                  size: 18,
                                ),
                                type: AppButtonType.secondary,
                                onPressed: () => _castVote(true),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 110,
                            height: 44,
                            child: AppButton(
                              text: 'الإبقاء',
                              type: AppButtonType.outline,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => _castVote(false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Member progress list
        const Text(
          'إنجاز الرفاق هذا الأسبوع',
          style: TextStyle(
            color: Color(0xFF3E2A1E),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text('محدّث تلقائياً',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                )),
          ],
        ),
        const SizedBox(height: 10),
        ...appController.members.map((m) => GroupMemberTile(member: m)),
        const SizedBox(height: 10),

        // Quick discussion preview & join
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E4D3),
            border: Border.all(color: const Color(0xFFCDAA85)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EC),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.forum,
                    size: 20, color: Color(0xFF6B4630)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نقاش الأسبوع جارٍ الآن',
                      style: TextStyle(
                        color: Color(0xFF3E2A1E),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '«العمران البشري وتأثير الجغرافيا»',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: AppButton(
                  text: 'الانضمام',
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  type: AppButtonType.primary,
                  onPressed: () => _switchTab(1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _DiscussionTab() {
    return Column(
      children: [
        // Discussion prompt header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.forum, size: 20, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'حوار الأسبوع الثاني: حول طبائع العمران وتأثير البيئة',
                  style: const TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'هادئ',
                  style: TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _MessageBubble(
                name: 'سارة اليافعي',
                time: 'منذ 25 دقيقة',
                mine: false,
                text:
                    'فصل "العمران البشري" غني جداً بالاستبصارات، خاصة تأملاته في كيف تشكل الجغرافيا طباع الشعوب وثقافاتهم الاجتماعية!',
                avatar: appController.members.firstWhereOrNull(
                        (m) => m.name == 'سارة اليافعي')
                    ?.avatarUrl,
              ),
              const SizedBox(height: 12),
              _MessageBubble(
                name: 'أنت',
                time: 'منذ 10 دقائق',
                mine: true,
                text:
                    'أتفق معك تماماً! لفت نظري تحليله لقوانين العصبية وكيف تنشأ وتزول، وكأنه يصف دورات تاريخية نراها تتكرر اليوم.',
              ),
              const SizedBox(height: 18),
              const Text(
                'قوالب تشجيع ومساندة سريعة:',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _QuickReaction(text: 'أتممت ورد اليوم 👍'),
              const SizedBox(height: 8),
              _QuickReaction(text: 'بالتوفيق للجميع! ✨'),
              const SizedBox(height: 8),
              _QuickReaction(text: 'ننتظراك لنكمل سوا 🌱'),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowTint,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'شارك فكرة أو استفساراً بهدوء...',
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant
                            .withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.send,
                        size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _MembersTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'جميع الأعضاء (${appController.members.length} قارئ وقارئة)',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'ترتيب أبجدي مريح',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...appController.members.map((m) => GroupMemberTile(member: m)),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, size: 24, color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class TabItem {
  final IconData icon;
  final String label;
  const TabItem({required this.icon, required this.label});
}

class _SegmentedRow extends StatelessWidget {
  final List<TabItem> tabs;
  final int active;
  final ValueChanged<int> onTap;

  const _SegmentedRow({
    required this.tabs,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFCDAA85))),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = active == i;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tabs[i].icon,
                        size: 18,
                        color: selected ? AppColors.primary : AppColors.secondary),
                    const SizedBox(width: 6),
                    Text(
                      tabs[i].label,
                      style: TextStyle(
                        color: selected ? AppColors.primary : AppColors.secondary,
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String name;
  final String time;
  final bool mine;
  final String text;
  final String? avatar;

  const _MessageBubble({
    required this.name,
    required this.time,
    required this.mine,
    required this.text,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mine
          ? [
              const Spacer(),
              Text(time,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  )),
              const SizedBox(width: 6),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ]
          : [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: (avatar ?? '').isNotEmpty
                    ? ClipOval(
                        child: BookCover(
                          imageUrl: avatar,
                          width: 28,
                          height: 28,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      )
                    : const Text('س', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(time,
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Color(0xFF3E2A1E),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}

class _QuickReaction extends StatelessWidget {
  final String text;

  const _QuickReaction({required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3E2A1E),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
