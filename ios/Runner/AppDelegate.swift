import UIKit
import Flutter
import HealthKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let healthStore = HKHealthStore()
  var eventSink: FlutterEventSink?
  var observerQuery: HKObserverQuery?

  lazy var flutterEngine = FlutterEngine(name: "io.flutter")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ FlutterEngine 수동 실행
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    // ✅ FlutterViewController 생성 및 연결
    let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = flutterViewController
    self.window?.makeKeyAndVisible()

    // ✅ Flutter MethodChannel & EventChannel 설정
    let methodChannel = FlutterMethodChannel(
      name: "com.getit.getitmoney.health_observer",
      binaryMessenger: flutterViewController.binaryMessenger
    )

    methodChannel.setMethodCallHandler { [weak self] (call, result) in
      guard call.method == "startObserver" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.startObserverQuery()
      result(nil)
    }

    let eventChannel = FlutterEventChannel(
      name: "com.getit.getitmoney.health_events",
      binaryMessenger: flutterViewController.binaryMessenger
    )
    eventChannel.setStreamHandler(self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// ✅ HealthKit ObserverQuery 등록
  func startObserverQuery() {
    if observerQuery != nil {
      print("⚠️ Observer 이미 등록됨")
      return
    }

    guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

    healthStore.requestAuthorization(toShare: nil, read: [stepType]) { [weak self] success, error in
      if success {
        print("✅ HealthKit 권한 요청 성공")

        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, _, error in
          if error == nil {
            print("📥 걸음수 업데이트 이벤트 감지됨")
            DispatchQueue.main.async {
              self?.eventSink?("step_updated")
              print("📤 Flutter로 이벤트 전송 완료")
            }
          } else {
            print("🚨 ObserverQuery 에러: \(error!.localizedDescription)")
          }
        }

        self?.observerQuery = query
        self?.healthStore.execute(query)
        print("📡 ObserverQuery 실행 완료")
      } else {
        print("🚨 HealthKit 권한 요청 실패: \(error?.localizedDescription ?? "unknown")")
      }
    }
  }
}

// MARK: - Flutter EventChannel StreamHandler
extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("📡 Flutter EventChannel 연결됨")
    self.eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("❌ Flutter EventChannel 연결 해제됨")
    self.eventSink = nil
    return nil
  }
}
