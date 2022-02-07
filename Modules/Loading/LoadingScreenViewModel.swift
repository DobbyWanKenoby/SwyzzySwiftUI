//
//  LoadingScreenViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import Foundation
import Combine
import SwiftUI
import Swinject

extension LoadingScreenView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var didEndUpdating = false
        @Published var isAnimate = false
        
        // Error
        @Published var isShowingAlert = false
        var alertMessage = ""
        
        private var subscribers = Set<AnyCancellable>()
        
        // Dependencies
        private var resolver: Resolver
        private var userService: UserService
        
        required init(resolver: Resolver) {
            self.resolver = resolver
            userService = resolver.resolve(UserService.self)!
        }
        
        func loadAllNeededData() {
            Task { @MainActor in
                do {
                    try await userService.createRemoteUserStructureIfNeeded()
                    _ = try await userService.downloadUser()
                    didEndUpdating = true
                } catch FirebaseError.cantGetDocument {
                    // try again
                    // TODO: Rewrite
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    loadAllNeededData()
                } catch (let error) {
                    alertMessage = error.localizedDescription
                    isShowingAlert = true
                }
            }
        }
    }
    
}
