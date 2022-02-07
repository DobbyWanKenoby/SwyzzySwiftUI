//
//  SwyzzySwiftUIApp.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//
import UIKit
import Combine
import SwiftUI
import Swinject
import Firebase

@main
struct SwyzzySwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var delegate
    
    @StateObject
    var vm = AppViewModel(resolver: Self.resolver)
    
    
    static var assembler = Assembler([
        DataServiceAssembly(),
        FirebaseAssembly()
    ])
    
    static var resolver: Resolver {
        Self.assembler.resolver
    }

    var body: some Scene {
        WindowGroup {
            if vm.isAuth {
                LoadingScreenView(resolver: Self.resolver)
            } else {
                LoginScreenView(resolver: Self.resolver)
                    .onOpenURL { url in
                        print("Received URL: \(url)")
                        Auth.auth().canHandle(url)
                    }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
//        do {
//            try Auth.auth().signOut()
//        } catch {}
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
