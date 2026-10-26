import 'dart:math';

import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/book.dart';
import '../models/group.dart';
import '../models/user_profile.dart';

/// Local mock data for the initial version of the app.
///
/// All data lives here so it can later be replaced by a real data source
/// (backend, database, etc.) without touching the UI or controllers.
///
/// These are sample values only — not data retrieved from a real backend.
class MockData {
  static final Random _random = Random();

  // -----------------------------------------------------------------------
  // Books
  // -----------------------------------------------------------------------

  static final List<Book> books = [
    Book(
      id: 'b1',
      title: 'قوة العادات',
      author: 'تشارلز دوهيج',
      category: 'تطوير الذات',
      pageCount: 280,
      rating: 4.8,
      ratingCount: 1850,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA-rpoaZ3jEjWgWkz_RGrnrD6zgvwB7rVXzmkznbWOZwkN3gIpKMyql6EVy04wGgcvk4zxtnMmXn2ZgMsO1GHpvTrjKCGUV6Vh0Z4cdewtGGCuGZ0iA64F74PnoQ8uWmTDnKo7dNyhP0PAmOU4pjNbWtUuScKN4jpXuVpDgSv6ZaeCZD7oW_28hhUApKw_mLilQcJIVFERtvkSIpTn7Smua1_c2W6PCPCO6uMCodYZEaHowcs0bfslWpw',
      summary:
          'يستكشف الكتاب الطبيعة العلمية للعادة، وكيف يمكن لتغيير بسيط في نمطنا اليومي وحلقات الإشارات والمكافآت أن يصنع تحولاً جذرياً في مسارات حياتنا ومؤسساتنا.',
      isBestseller: true,
    ),
    Book(
      id: 'b2',
      title: 'طريق الحكمة',
      author: 'د. طارق السويدان',
      category: 'تطوير الذات',
      pageCount: 240,
      rating: 4.6,
      ratingCount: 940,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJm5ZgXSbLSJYbnrQzUWNtS-9_zywxgfh6QN4BHHva01LOVvMfwfqxCaF8Crxty8iTmOQGHmoO11xniuON9JpanX2QGz7zyN-FjYoXgUXmTZP0ltg_jvsMtctX9iA6EUpkrZRVUxFBSVi7j3wNFXfbsWMHuIKlRxFcxD-6_S9I6DTcAaBlGiAjswpQpyoWWH07hZFdPqx1U6bEnP6HlqgOKtQHlzIXhCX6WSN9iz8hXsmiFHOrFYss4w',
      summary:
          'رحلة في مفاتيح الحكمة العملية والتأمل الذاتي لبناء حياة متوازنة قائمة على التفكير العميق والعمل الواعي.',
    ),
    Book(
      id: 'b3',
      title: 'رجال حول الرسول',
      author: 'خالد محمد خالد',
      category: 'تاريخي',
      pageCount: 312,
      rating: 4.9,
      ratingCount: 2310,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA63U8Sr7JToyNgdzVTdJDQcMcbLIqQl6Iz0t-7a5IyScRCixRBxa3N-cnJVmy0cvGrYth9WVV8rlCeXLXr5wUaP-eG0mu0ZMcjFCtepcEm3YYKJ2SPyXrS8D8o3gAnW6Y3f2w38SYzUTrysU2ZqRBQy5bJWpXdxbNwuE9C0X7XKME_9u9CXQ2ydRtUmkCG6kPiai-UDONZ9CFH9XCE46M_ICvdlxiX7lvY832xyUF0Ckq9Emso82OmpA',
      summary:
          'سير ذاتية موجزة لأبرز صحابة الرسول صلى الله عليه وسلم ودورهم في تأسيس الحضارة الإسلامية.',
    ),
    Book(
      id: 'b4',
      title: 'أريد أن أعيش',
      author: 'مهدي الموسوي',
      category: 'علم النفس',
      pageCount: 196,
      rating: 4.4,
      ratingCount: 720,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB4upggKpCHO5trFbV62qphzm6wyEvdNejad4wIZF5vtJf0SxTC9BeSfflKktzy4L52UN5jKVhfAGoVJSZy_HNLIQNCNbBdgBtH-fWQJyoOXG66a81dkWhZPxqaNbPUeqFSTstQP1LZdPGXZR8jmE1ghYPeWcyf9azSmEQvwe9GRNxfJWl9Dwl2lNk41cIj-1VIoh_jRAp1g3WQdGjGgF5DgjhQKUXZopKQJk5oqhlxwQZ6xeqmWUoP2A',
      summary:
          'كتاب نفسي ملهم يتناول السعادة الداخلية، والتغلب على القلق، وصناعة الأمل في أصعب الظروف.',
    ),
    Book(
      id: 'b5',
      title: 'لأنك الله: رحلة إلى السماء السابعة',
      author: 'علي بن جابر الفيفي',
      category: 'تاريخي',
      pageCount: 224,
      rating: 4.7,
      ratingCount: 1560,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD2pqWxilujJLlXIkDNQ3ZsENmhzPqcDbrJYgaWov1yohNRcoSFSPUKAYbahH0mzoyom5sK8A7-wDKUmdHDLXFGGFDjDSgqwcnrYHJqnDxcEwhjri714qaAmoTMzHkIZ88B0hMg_GWoTKDU3sRCOVD3GjNPQfKYVV4-qB7D42A7qZ2jqYttun7zOCDebJh2kTYds3QdFJy2aZDlB4m7lq8RVHcLK0XHiz3ASCK7iShpY1iKBm6gxX3OQw',
      summary: 'رحلة إيمانية עמוקה إلى أسماء الله الحسنى ومعانيها في حياة المسلم.',
    ),
    Book(
      id: 'b6',
      title: 'العادات الذرية',
      author: 'جيمس كلير',
      category: 'تطوير الذات',
      pageCount: 320,
      rating: 4.7,
      ratingCount: 4120,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCDO1_18BpKomOjqk7R7RN4hfrbsUxwPUyMiqH38DiwzzJxazQNd-IJvd7nyW9BgfS5Ioam6Se0hLa-KxvXtli27T57mqa2x-KXn4DnN3rqm5u45kgbyZJG0xtxKP5jw_P7pnO4bT7soR_xVC9ShoTMNbQJ36vWLB8X-_tu5EsxtI9oYLvs7S8ptPaLbi9B289qKnmI5BOyEcwbM9oMJwS0Eh0piVrP1HjOZGa7AGny8H0gMw2kqOfo1Q',
      summary:
          'دليل عملي لبناء العادات الجيدة والتخلص من السيئة من خلال تغييرات صغيرة ومتراكمة.',
    ),
    Book(
      id: 'b7',
      title: 'مقدمة ابن خلدون',
      author: 'عبد الرحمن بن محمد ابن خلدون',
      category: 'تاريخي',
      pageCount: 420,
      rating: 4.9,
      ratingCount: 3340,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASugR8EYr9Og9IyCMGh_ohFWV-Bg6w2jHQEasCmpuzbuirRI0bazlESqAYOxoezxIXXR2sbAm9QSn4WvqK3p4bWccCqGcwo5n8ZGc4jo2f03K9AyOJzJzUl1L65SF7HzfGyZSmSCfSCwqoNJNCribyFb3DfMUUZYVM48fkfHxgn_rD1cJp_cYxYfsC3gG5i2YRt4mmDQbnFFBZy5vCGhE-u6kUZlDYcrg_ild-s5fOli3Ga3bw5uLh2Q',
      summary:
          'مقدمة تاريخية فلسفية في علوم العمران، وتُعتبر إحدى أهم المؤلفات في الفكر الإنساني والتاريخ.',
    ),
    Book(
      id: 'b8',
      title: 'طريق الحكمة وفنون العيش',
      author: 'د. عبد الرحمن الفهد',
      category: 'فلسفة وتأمل',
      pageCount: 320,
      rating: 4.5,
      ratingCount: 610,
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAs4GnVO8FGUn8CqMs1GYNO51s35RegbTg9E6zCz6iuYKSp5WOTyfQ9jpSCenv1HLinyVFBRVLXEWD2nPXXPEe5iD-HMy6s9Be_ooc0f1DDlbTisqNpLjUyP8RTmYEx0A_gQq3HmkZE7jm_nFgDEIUNajxeSDq5yrTjOGuvT-19jStlplxarx2L5PkWsH7ZM-f3ft3YVUfADHc3UfbyzAf2YvVsRJeXAyO3OHXSXzRXlZ3aT1TMHXU5TQ',
      summary:
          'قراءة معمقة لمناهج الفلسفة والتأمل الإنساني من أجل حياة أكثر وعياً وإحساساً بالمعنى.',
    ),
  ];

  static List<Book> get recommendedBooks => books.where((b) => b.id != 'b6').take(4).toList();

  // -----------------------------------------------------------------------
  // User profile
  // -----------------------------------------------------------------------

  static final UserProfile userProfile = UserProfile(
    name: 'سارة اليافعي',
    email: 'sara.alyafei@example.com',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVWaknaBdn-lIeg_HwmVdx9vt_pf2My1dcrPbOYyqBAtdhM_dVvHqx2RYzFFgxwUstXySABLnrRxy98D4dWDkbd2hiM787bhg7Dc-bziiAWkgW9bOP5DWObhrYeT1YNvhk36BsOmIhpUBt2P7hu9v87LG4ypEi-xxptehTxemhqs3OwDBNJVTwZGQ0FG5tY7iG9p5C1D0w_SIvXzlY0zzx9jRga4sg1tL6vR6SEOG9RYFuVGzWStDEA',
    memberSince: DateTime(2024, 1, 15),
    booksCompleted: 24,
    commitmentDays: 18,
    totalPagesRead: 4218,
  );

  // -----------------------------------------------------------------------
  // Reading groups
  // -----------------------------------------------------------------------

  static final List<ReadingGroup> groups = [
    ReadingGroup(
      id: 'g1',
      name: 'نادي رواد الفكر',
      description: 'مدارسة أمهات الكتب الفكرية والتاريخية بروح تشاركية وتأمل هادئ.',
      joinCode: 'IQRA-8429',
      coverUrl: '',
      bookTitle: 'مقدمة ابن خلدون',
      bookCoverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTMG2nbAtBKQE5ljtwiQTgS2IcOcWU_wLvz_NT4Me0CiZjZNojHkv0HBD0PERs6s3HOFOf8COv2hdr9XyS5N5d2raj8C88N9CocNCvrnhVCH9kyJ0DV-VgeJaUerO3cBFcqFTuUIheAfADAncsB4bmB7OJlXayUtBkKuWbuDWA9WGbH4_iWMX_aWdyIFEJZNHyz1Xdharyfn0-GTGI5jK7QhJb9Ew9yJHbQcRVwiUqGUfpX7K134Ebgw',
      totalPages: 420,
      daysDuration: 21,
      privacy: GroupPrivacy.private,
      collectiveProgress: 45,
      memberCount: 18,
      createdAt: DateTime(2025, 9, 1),
      isChallenge: false,
    ),
    ReadingGroup(
      id: 'g2',
      name: 'تحدي الـ 21 يوماً للعادة الذرية',
      description: 'اقرأ كتاب "العادات الذرية" خلال 21 يوماً مع نخبة من القراء الملتزمين.',
      joinCode: 'IQRA-2101',
      coverUrl: '',
      bookTitle: 'العادات الذرية',
      bookCoverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCDO1_18BpKomOjqk7R7RN4hfrbsUxwPUyMiqH38DiwzzJxazQNd-IJvd7nyW9BgfS5Ioam6Se0hLa-KxvXtli27T57mqa2x-KXn4DnN3rqm5u45kgbyZJG0xtxKP5jw_P7pnO4bT7soR_xVC9ShoTMNbQJ36vWLB8X-_tu5EsxtI9oYLvs7S8ptPaLbi9B289qKnmI5BOyEcwbM9oMJwS0Eh0piVrP1HjOZGa7AGny8H0gMw2kqOfo1Q',
      totalPages: 320,
      daysDuration: 21,
      privacy: GroupPrivacy.public,
      collectiveProgress: 78,
      memberCount: 42,
      createdAt: DateTime(2025, 8, 20),
      isChallenge: true,
    ),
  ];

  static final List<GroupMember> groupMembers = [
    GroupMember(
      id: 'm1',
      name: 'ماجد القحطاني',
      role: 'منشئ المجموعة',
      bio: 'قارئ نشط • انضم منذ 4 أشهر',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1TJkClWopkGWQQgF20euGbkWNlAACB_iCJzlMgwY1AJvJvZHqe6xLe5OsJVSMvSEmaW9KpMCNoJUkOZudgaQevzdiTSkgCviDQpdizHd2O5Gg2t6VCzPoxTCoE65NqrNTXwGhGQ9rEOCH0TdNS-BWvDTHcpJPK1C1uCebZPV5TFTXOtIsZP7sUPrO9jKSmelphjj2YPiPkI6dsfJqdf91ls8fOnG6mWydsMpN-Mmf3aaJ6rnIsZ4v5Q',
      progressPercent: 80,
      isCurrentUser: true,
    ),
    GroupMember(
      id: 'm2',
      name: 'طارق المهيدب',
      role: 'قارئ',
      bio: 'قارئ يومي • انضم منذ شهرين',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCr4kpDkLeH3t5MDKRqeuVOYCUJLdAaoDN8hTLFECI_8HL2B9GQh8mR7qyoPasjoTOfxlVPkoS7nXK8XUBvoEG2FcJXIENQGtjsRtm5hVQy0zzijy9kA1kFgFRiAXYk8B-XI-5PX-ugtrJXXxjmb3cjcJCLXPn_F6wtLMFxxnngj5eNbPB-aLqM3oO8dqg9zkk2KkdpF7ZxUIBhGOF97i5IKPtQnjJ-tORhgplvoAInX4QsXz58ikNGIw',
      progressPercent: 75,
    ),
    GroupMember(
      id: 'm3',
      name: 'سارة اليافعي',
      role: 'قارئة',
      bio: 'قارئة متأملة • انضمت مؤخراً',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDiepmAXKGvja7I0xlG8FR_bJZ7i90nRgUs4M9PRp1ztB82H7eyTVtbdNrTSpnv30VrkNCokc3nDrqx-K0nSdMMv-zb5TTWgwzUo5YhfF-lO4eLc1XiwHN02urSvTzAPxbAUalz3aLC8srgaYQ5oY--65GCEkiLoq4MMo3O9ZLYFZMXepWr-7vksCO9t-BoGEUn4IIzTkJegr_pXvGH1WTroHSd7rb7yT2ReZDgJSXApUjvzICUkOW6uQ',
      progressPercent: 65,
    ),
    GroupMember(
      id: 'm4',
      name: 'د. عمر الصالح',
      role: 'قارئ',
      bio: 'محاور فكري • انضم منذ 3 أشهر',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDK_hJkzx8tE8NupJXS7Hpftok1Htvtebn5AmQMh0LLQbFJI_2hh_13VDqc9NTd2mdZH0ffBuWnN-Ub0QxJTQWy7g4AwqpIv2hbNLI5S3D3Fe15V3wqg55hgoZ9blKaXWDERHvwt4guRO_t-M_J2YFbnHKprtNMbuHSbY7IFztauk5gn_vtZ2xIZbqnQUn7Mm2atp3O72dFA79N6wdA7i49WSvSelI5Z4pdiddEajFmNUiYyt_2WUASxSA',
      progressPercent: 54,
    ),
  ];

  // -----------------------------------------------------------------------
  // Achievements
  // -----------------------------------------------------------------------

  static List<Achievement> achievements({
    required int booksCompleted,
    required int commitmentDays,
    required int totalPagesRead,
  }) {
    return [
      Achievement(
        id: 'ach1',
        title: 'أول كتاب',
        subtitle: 'مكتمل 📖',
        icon: const IconData(0xe356, fontFamily: 'MaterialIcons'), // import_contacts
        badgeColor: const Color(0xFF9A6B48),
        unlocked: booksCompleted >= 1,
        certificateBook: 'قوة العادات',
      ),
      Achievement(
        id: 'ach2',
        title: '5 كتب',
        subtitle: 'مكتمل 📚',
        icon: const IconData(0xe322, fontFamily: 'MaterialIcons'), // library_books
        badgeColor: const Color(0xFF6B4630),
        unlocked: booksCompleted >= 5,
        certificateBook: 'أريد أن أعيش',
      ),
      Achievement(
        id: 'ach3',
        title: 'عدتُ وأكملت',
        subtitle: 'مكتمل 🌱',
        icon: const IconData(0xe850, fontFamily: 'MaterialIcons'), // potted_plant
        badgeColor: const Color(0xFF4F5D2F),
        unlocked: commitmentDays >= 7,
      ),
      Achievement(
        id: 'ach4',
        title: 'قارئ متواصل',
        subtitle: '30 يوماً commitment',
        icon: const IconData(0xe91c, fontFamily: 'MaterialIcons'), // local_fire_department
        badgeColor: const Color(0xFFD9A441),
        unlocked: commitmentDays >= 30,
      ),
      Achievement(
        id: 'ach5',
        title: 'ألف صفحة',
        subtitle: 'مقروءة 📄',
        icon: const IconData(0xe33d, fontFamily: 'MaterialIcons'), // auto_stories
        badgeColor: const Color(0xFF504440),
        unlocked: totalPagesRead >= 1000,
      ),
    ];
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  static String nextId(String prefix) => '${prefix}_${_random.nextInt(900000) + 100000}';
}
