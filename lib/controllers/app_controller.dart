import 'dart:math';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/achievement.dart';
import '../models/book.dart';
import '../models/group.dart';
import '../models/reading_plan.dart';
import '../models/user_profile.dart';

/// Central application controller (MVC "C").
///
/// Holds all local application state and the actions the views can trigger.
/// Views listen to this controller via [ListenableBuilder] and rebuild when
/// [notifyListeners] is called.
///
/// No external state-management package is used — only the Flutter SDK.
class AppController extends ChangeNotifier {
  static AppController get instance => _instance;
  static final AppController _instance = AppController._internal();

  AppController._internal() {
    _seedInitialPlan();
  }

  // -----------------------------------------------------------------------
  // Application lifecycle
  // -----------------------------------------------------------------------

  bool _onboardingSeen = false;
  bool _loggedIn = false;
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  String? _lastToast; // short feedback message shown as a snackbar/toast
  final Random _random = Random();
  final UserProfile _user = MockData.userProfile;

  bool get onboardingSeen => _onboardingSeen;
  bool get loggedIn => _loggedIn;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String? get lastToast => _lastToast;

  void completeOnboarding() {
    _onboardingSeen = true;
    notifyListeners();
  }

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Books & library
  // -----------------------------------------------------------------------

  List<Book> get allBooks => MockData.books;

  final List<Book> _ownedBooks = []; // books added to the personal library
  final Set<String> _favoriteIds = {}; // favorite book ids

  List<Book> get ownedBooks => List.unmodifiable(_ownedBooks);

  bool isOwned(String bookId) => _ownedBooks.any((b) => b.id == bookId);
  bool isFavorite(String bookId) => _favoriteIds.contains(bookId);

  BookCategory _selectedCategory = BookCategory.all;
  String _searchQuery = '';

  BookCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Book> get filteredBooks {
    var result = allBooks;
    if (_selectedCategory != BookCategory.all) {
      result = result.where((b) => b.category == _selectedCategory.label).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((b) {
        return b.title.toLowerCase().contains(q) ||
            b.author.toLowerCase().contains(q) ||
            b.category.toLowerCase().contains(q);
      }).toList();
    }
    return result;
  }

  void selectCategory(BookCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String bookId) {
    if (_favoriteIds.contains(bookId)) {
      _favoriteIds.remove(bookId);
    } else {
      _favoriteIds.add(bookId);
    }
    notifyListeners();
    _showToast(_favoriteIds.contains(bookId) ? 'أضيف إلى المفضلة' : 'تم إزالة الكتاب من المفضلة');
  }

  void addToLibrary(Book book) {
    if (_ownedBooks.any((b) => b.id == book.id)) return;
    _ownedBooks.add(book);
    notifyListeners();
    _showToast('أضيف الكتاب إلى مكتبتك');
  }

  void removeFromLibrary(String bookId) {
    _ownedBooks.removeWhere((b) => b.id == bookId);
    _plans.removeWhere((p) => p.bookId == bookId);
    notifyListeners();
    _showToast('تمت إزالة الكتاب من المكتبة');
  }

  // -----------------------------------------------------------------------
  // Reading plans
  // -----------------------------------------------------------------------

  final List<ReadingPlan> _plans = [];
  final List<ReadingRecord> _records = [];

  List<ReadingPlan> get plans => List.unmodifiable(_plans);
  List<ReadingPlan> get activePlans =>
      _plans.where((p) => p.isActive && !p.isCompleted).toList();

  ReadingPlan? get activePlan => activePlans.isEmpty ? null : activePlans.first;

  /// Seeds one in-progress plan so the designs have realistic initial data.
  void _seedInitialPlan() {
    final book = allBooks.firstWhere((b) => b.id == 'b1');
    _ownedBooks.add(book);
    _plans.add(ReadingPlan(
      id: 'plan_1',
      bookId: book.id,
      startDate: DateTime.now().subtract(const Duration(days: 9)),
      targetDate: DateTime.now().add(const Duration(days: 5)),
      targetPages: book.pageCount,
      completedPages: 182,
      consecutiveDays: 13,
      isActive: true,
    ));
    addToLibrary(book);
  }

  /// Creates a reading plan for [book] with the given [targetDate].
  void createReadingPlan({
    required String bookId,
    required DateTime targetDate,
    required int targetPages,
    String reminderTime = '08:30 م',
    bool remindersEnabled = true,
  }) {
    _plans.add(ReadingPlan(
      id: MockData.nextId('plan'),
      bookId: bookId,
      startDate: DateTime.now(),
      targetDate: targetDate,
      targetPages: targetPages,
      isActive: true,
    ));
    if (!isOwned(bookId)) {
      final book = allBooks.firstWhere((b) => b.id == bookId);
      addToLibrary(book);
    }
    _showToast('تم إنشاء الخطة القرائية بنجاح');
    notifyListeners();
  }

  /// Edits an existing plan (target date / pages).
  void editReadingPlan({
    required String planId,
    required DateTime targetDate,
    required int targetPages,
  }) {
    final plan = _plans.firstWhere((p) => p.id == planId);
    final oldCompleted = plan.completedPages;
    final updated = plan.copyWith(
      targetDate: targetDate,
      targetPages: targetPages,
      completedPages: oldCompleted.clamp(0, targetPages),
    );
    final index = _plans.indexWhere((p) => p.id == planId);
    _plans[index] = updated;
    _showToast('تم تعديل الخطة');
    notifyListeners();
  }

  /// Deletes a plan after the caller confirmed deletion.
  void deleteReadingPlan(String planId) {
    _plans.removeWhere((p) => p.id == planId);
    notifyListeners();
    _showToast('تم حذف خطة القراءة');
  }

  /// Returns the plan for a given book, if one exists.
  ReadingPlan? planForBook(String bookId) =>
      _plans.firstWhereOrNull((p) => p.bookId == bookId);

  // -----------------------------------------------------------------------
  // Reading progress
  // -----------------------------------------------------------------------

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Records completed reading for today.
  ///
  /// Returns [true] when progress was updated, [false] if reading was already
  /// recorded today (duplicate prevention).
  bool recordProgress(String planId, int pagesRead) {
    final plan = _plans.firstWhere((p) => p.id == planId);
    final today = DateTime.now();

    if (plan.lastCompletedDate != null && _isSameDay(plan.lastCompletedDate!, today)) {
      _showToast('لقد سجلت قراءتك اليوم بالفعل');
      notifyListeners();
      return false;
    }

    final newCompleted = (plan.completedPages + pagesRead).clamp(0, plan.targetPages);
    plan.completedPages = newCompleted;
    plan.lastCompletedDate = today;
    plan.consecutiveDays += 1;

    _records.add(ReadingRecord(
      id: MockData.nextId('record'),
      planId: planId,
      date: today,
      pagesRead: pagesRead,
    ));

    if (plan.isCompleted) {
      _showToast('أكملت الكتاب بنجاح! 🎉');
    } else {
      _showToast('تم حفظ إنجاز اليوم بنجاح');
    }
    notifyListeners();
    return true;
  }

  /// Missed-reading-day options.
  /// - [redistribute]: keep completed pages, recompute daily target across remaining days.
  /// - [extend]: push the target date forward by 7 days.
  /// - [continuePlan]: keep the existing plan unchanged.
  void handleMissedDay(String planId, {bool redistribute = false, bool extend = false}) {
    final plan = _plans.firstWhere((p) => p.id == planId);
    if (redistribute) {
      // Daily target is a computed getter over remaining pages / remaining days,
      // so previously completed progress is preserved automatically.
      _showToast('تم توزيع الصفحات المتبقية على الأيام المتبقية');
    } else if (extend) {
      plan.targetDate = plan.targetDate.add(const Duration(days: 7));
      _showToast('تم تمديد موعد الخطة بأسبوع');
    } else {
      _showToast('متابعة الخطة الحالية');
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Groups
  // -----------------------------------------------------------------------

  final List<ReadingGroup> _groups = List.of(MockData.groups);
  final List<GroupMember> _members = List.of(MockData.groupMembers);
  final List<Map<String, dynamic>> _groupMessages = [];
  final Map<String, List<GroupVote>> _groupVotes = {};

  List<ReadingGroup> get groups => List.unmodifiable(_groups);
  List<GroupMember> get members => List.unmodifiable(_members);
  List<Map<String, dynamic>> get groupMessages => List.unmodifiable(_groupMessages);

  ReadingGroup? groupById(String id) => _groups.firstWhereOrNull((g) => g.id == id);
  List<GroupMember> membersOfGroup(String groupId) =>
      _members.where((m) => m.id != 'm1' || true).toList(); // all members shown in demo

  void createGroup({
    required String name,
    required String description,
    required String bookTitle,
    required String bookCoverUrl,
    required int totalPages,
    required int daysDuration,
    required GroupPrivacy privacy,
  }) {
    _groups.add(ReadingGroup(
      id: MockData.nextId('group'),
      name: name,
      description: description,
      joinCode: 'IQRA-${_randomCode()}',
      coverUrl: '',
      bookTitle: bookTitle,
      bookCoverUrl: bookCoverUrl,
      totalPages: totalPages,
      daysDuration: daysDuration,
      privacy: privacy,
      memberCount: 1,
      createdAt: DateTime.now(),
      isChallenge: daysDuration <= 30,
    ));
    _showToast('تم إنشاء المجموعة بنجاح');
    notifyListeners();
  }

  void castGroupVote(String groupId, bool agree) {
    final votes = _groupVotes.putIfAbsent(groupId, () => []);
    votes.add(GroupVote(memberId: 'me', agree: agree));
    notifyListeners();
  }

  void sendGroupMessage(String text) {
    if (text.trim().isEmpty) return;
    _groupMessages.add({
      'text': text.trim(),
      'time': DateTime.now(),
      'mine': true,
    });
    notifyListeners();
  }

  String _randomCode() {
    final chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(4, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  UserProfile get userProfile => _user;

  // -----------------------------------------------------------------------
  // Achievements
  // -----------------------------------------------------------------------

  List<Achievement> get achievements => MockData.achievements(
        booksCompleted: _user.booksCompleted,
        commitmentDays: _user.commitmentDays,
        totalPagesRead: _user.totalPagesRead,
      );

  ReadingStats get stats => const ReadingStats(
        booksCompleted: 12,
        totalPagesRead: 3450,
        commitmentDays: 18,
        longestStreak: 42,
        currentLevel: 4,
        commitmentPercent: 96,
      );

  // -----------------------------------------------------------------------
  // Feedback
  // -----------------------------------------------------------------------

  void _showToast(String message) {
    _lastToast = message;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      if (_lastToast == message) {
        _lastToast = null;
        notifyListeners();
      }
    });
  }
}

/// Shorthand to retrieve the controller from anywhere.
AppController get appController => AppController.instance;

extension FirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
