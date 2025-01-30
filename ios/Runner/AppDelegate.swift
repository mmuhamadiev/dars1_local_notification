import Flutter
import UIKit

//TODO IOS setup
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // TODO IOS setup - 5 start
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
      }
    // TODO IOS setup - 5 end

    GeneratedPluginRegistrant.register(with: self)

      // TODO IOS setup - 6 start
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      // TODO IOS setup - 6 end

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
