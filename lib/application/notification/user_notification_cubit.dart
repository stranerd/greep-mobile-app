import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/domain/notification/notification_service.dart';
import 'package:greep/domain/notification/user_notification.dart';

part 'user_notification_state.dart';

class UserNotificationCubit extends Cubit<UserNotificationState> {
  final NotificationService notificationService;

  UserNotificationCubit({
    required this.notificationService,
  }) : super(UserNotificationInitial());

  bool hasFetched = false;

  void fetchNotifications({
    bool softUpdate = false,
  }) async {
    if (!softUpdate) {
      emit(UserNotificationStateLoading());
    }
    if (!hasFetched) {
      emit(UserNotificationStateLoading());
    }

    var response = await notificationService.fetchUserNotifications();

    print(response.data!.length);
    if (response.isError) {
      emit(UserNotificationStateError(
        errorMessage: response.errorMessage ?? "",
        isConnectionTimeout: response.isConnectionTimeout,
        isSocket: response.isSocket,
      ));
    } else {
      emit(
        UserNotificationStateFetched(
          notifications: response.data!,
        ),
      );
      hasFetched = response.data?.isNotEmpty ?? false;
    }
  }
}
