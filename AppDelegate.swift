import Flutter
import UIKit
import GoogleMaps  // ✅ Make sure this is imported

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GMSServices.provideAPIKey("AIzaSyA5qrPTIdyby7bi4tHVx1jXz9P-IL3p1V4")  // ✅ Add this line with your API key

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}