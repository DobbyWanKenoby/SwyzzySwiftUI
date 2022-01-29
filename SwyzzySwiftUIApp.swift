//
//  SwyzzySwiftUIApp.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//
import UIKit
import SwiftUI
import Swinject
import Firebase

@main
struct SwyzzySwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private var assembler = Assembler([
        DataServiceAssembly(),
        FirebaseAssembly()
    ])
    
    var body: some Scene {
        WindowGroup {
            LoginScreen(resolver: assembler.resolver).rootView
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    Auth.auth().canHandle(url)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}
