import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class BaseController extends FullLifeCycleController with FullLifeCycleMixin{

  @override
  void onInit() {
    super.onInit();
    fetchData();
    if (kDebugMode) {
      print("onInit");
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (kDebugMode) {
      print("onClose");
    }
  }

  @override
  void onDetached() {
    if (kDebugMode) {
      print("onDetached");
    }
  }

  @override
  void onInactive() {
    if (kDebugMode) {
      print("onInactive");
    }
  }

  @override
  void onPaused() {
    if (kDebugMode) {
      print("onPaused");
    }
  }

  @override
  void onResumed() {
    if (kDebugMode) {
      print("onResumed");
    }
  }

  @override
  void onHidden() {
    if (kDebugMode) {
      print("onHidden");
    }
  }

  void fetchData() {}

  void refreshData() {
    fetchData();
  }
}
