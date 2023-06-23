

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
}

//This class conforms to the NSApplicationDelegate protocol and serves as the entry point for the macOS application.
//The applicationDidFinishLaunching(_ aNotification: Notification) method is called when the application finishes launching. You can add any initialization code for your application in this method.
//The applicationWillTerminate(_ aNotification: Notification) method is called when the application is about to terminate. You can add any cleanup code for your application in this method.
