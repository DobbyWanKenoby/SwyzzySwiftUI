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
    
    static var assembler = Assembler([ BaseAssembly() ])
    
    static var resolver: Resolver {
        Self.assembler.resolver
    }
    
    var body: some Scene {
        WindowGroup {
            rootView
                .animation(.easeInOut, value: vm.appState)
        }
    }
    
    @ViewBuilder
    private var rootView: some View {
        switch vm.appState {
        case .signOut:
            LoginScreenView(resolver: Self.resolver)
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    Auth.auth().canHandle(url)
                }
        case .signIn:
            LoadingScreenView(resolver: Self.resolver)
        case .needUserQuestionnaire:
            UserQuestionnaireScreenView(resolver: Self.resolver)
        case _ where [nil, AppState.signIn].contains(vm.appState):
            LoadingScreenView(resolver: Self.resolver)
        case _ where [AppState.finishedUserQuestionnaire, AppState.needMainFlow].contains(vm.appState):
            MainView(resolver: Self.resolver)
        default:
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
//                do {
//                    try Auth.auth().signOut()
//                } catch {}
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
