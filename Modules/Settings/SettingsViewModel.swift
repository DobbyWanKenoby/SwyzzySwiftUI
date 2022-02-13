//
//  SettingsViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 10.02.2022.
//

import Foundation
import Swinject
import FirebaseAuth

extension SettingsView {
    
    @MainActor
    final class ViewModel: BaseModel {
        
        private var resolver: Resolver
        private var stateService: StateService
        
        @Published var isShowingAlert = false
        @Published var alertMessage = ""
        
        init(resolver: Resolver) {
            self.resolver = resolver
            stateService = resolver.resolve(StateService.self)!
        }
        
        func signOut() {
            do {
                try Auth.auth().signOut()
                stateService.statePublisher.send(.signOut)
            } catch (let error) {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            }
        }
        
    }
    
}
