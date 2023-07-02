//
//  raptApp.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI
import FirebaseCore

//
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct raptApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.dark)
        }
    }
}
