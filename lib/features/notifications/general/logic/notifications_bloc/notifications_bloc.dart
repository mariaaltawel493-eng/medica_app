import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/notifications/general/data/repos/notifications_repo.dart';
import '../../data/models/notification_model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepo notificationsRepo;

  // متغيرات داخلية لحفظ حالة الـ Pagination الحالية داخل الـ Bloc
  List<NotificationModel> _allNotifications = [];
  int? _nextLastId;
  bool _hasMore = false;
  int _unreadCount = 0;
  bool _isFetchingMore =
      false; // لمنع إرسال طلبين بجانب بعضهما عند الـ Scroll फास्ट

  NotificationsBloc(this.notificationsRepo)
    : super(NotificationsInitialState()) {
    // ربط الأحداث بالدوال الخاصة بها
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<FetchMoreNotificationsEvent>(_onFetchMoreNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);
  }

  // 1) معالجة الجلب البدائي (الصفحة الأولى)
  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoadingState());
    try {
      // جلب عداد غير المقروء أولاً
      _unreadCount = await notificationsRepo.getUnreadCount();

      // جلب أول 15 إشعار من السيرفر (lastId = null)
      final response = await notificationsRepo.getNotifications(lastId: null);

      _allNotifications = response.data;
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        NotificationsSuccessState(
          notifications: _allNotifications,
          hasMore: _hasMore,
          unreadCount: _unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationsErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // 2) معالجة جلب المزيد (عند الـ Scroll لأسفل)
  Future<void> _onFetchMoreNotifications(
    FetchMoreNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    // إذا لم يكن هناك المزيد أو كنا نقوم بالتحميل حالياً، لا تفعل شيئاً
    if (!_hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    try {
      // نرسل الـ _nextLastId الذي أعطانا إياه السيرفر في الطلب السابق
      final response = await notificationsRepo.getNotifications(
        lastId: _nextLastId,
      );

      _allNotifications.addAll(
        response.data,
      ); // دمج الإشعارات الجديدة مع القديمة
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        NotificationsSuccessState(
          notifications: _allNotifications,
          hasMore: _hasMore,
          unreadCount: _unreadCount,
        ),
      );
    } catch (_) {
      // في الـ Load More لا نلغي الحالة السابقة عند حدوث خطأ بل نبقيها كما هي
    } finally {
      _isFetchingMore = false;
    }
  }

  // 3) تحديد إشعار معين كمقروء
  Future<void> _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      // تحديث الحالة محلياً فوراً في التطبيق لسرعة الاستجابة (UI Responsiveness)
      final index = _allNotifications.indexWhere(
        (n) => n.id == event.notificationId,
      );
      if (index != -1 && !_allNotifications[index].isRead) {
        // إنشاء كائن جديد معدل كـ read
        _allNotifications[index] = NotificationModel(
          id: _allNotifications[index].id,
          title: _allNotifications[index].title,
          body: _allNotifications[index].body,
          type: _allNotifications[index].type,
          data: _allNotifications[index].data,
          isRead: true, // أصبحت مقروءة
          sentAt: _allNotifications[index].sentAt,
        );
        if (_unreadCount > 0) _unreadCount--; // إنقاص العداد

        emit(
          NotificationsSuccessState(
            notifications: _allNotifications,
            hasMore: _hasMore,
            unreadCount: _unreadCount,
          ),
        );
      }

      // إرسال الطلب للسيرفر في الخلفية
      await notificationsRepo.markAsRead(event.notificationId);
    } catch (_) {}
  }

  // 4) تحديد الكل كمقروء
  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      // تحديث الواجهة محلياً فوراً
      _allNotifications = _allNotifications.map((n) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          body: n.body,
          type: n.type,
          data: n.data,
          isRead: true,
          sentAt: n.sentAt,
        );
      }).toList();
      _unreadCount = 0;

      emit(
        NotificationsSuccessState(
          notifications: _allNotifications,
          hasMore: _hasMore,
          unreadCount: _unreadCount,
        ),
      );

      // إبلاغ السيرفر
      await notificationsRepo.markAllAsRead();
    } catch (_) {}
  }
}
