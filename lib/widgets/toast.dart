import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class Toast {
  final String message;
  final BuildContext context;
  final ToastType type;

  Toast({required this.context, required this.message, required this.type}) {
    switch (type) {
      case ToastType.info:
        showInfo();
        break;
      case ToastType.success:
        showSuccess();
        break;
      case ToastType.warning:
        showWarning();
        break;
      case ToastType.error:
        showError();
        break;
      case ToastType.delete:
        showDelete();
        break;
      default:
        break;
    }
  }

  void showError() {
    MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      position: MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }

  void showSuccess() {
    MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      position: MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }

  void showWarning() {
    MotionToast.warning(
      title: const Text('Warning'),
      description: Text(message),
      position: MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }

  void showInfo() {
    MotionToast.info(
      title: const Text('Info'),
      description: Text(message),
      position: MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }

  void showDelete() {
    MotionToast.delete(
      title: const Text('Delete'),
      description: Text(message),
      position: MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }
}
