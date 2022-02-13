//
//  AppViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 07.02.2022.
//

import SwiftUI
import Combine
import Swinject

extension SwyzzySwiftUIApp {
    
    class AppViewModel: ObservableObject {
//        @Published private(set) var isAuth: Bool = false
        @Published private(set) var appState: AppState?
        
        private var subscribers: Set<AnyCancellable> = []
        private var resolver: Resolver
        
        
        
        // Dependencies
//        var authService: AuthService!
        var stateService: StateService!
        
        init(resolver: Resolver) {
            self.resolver = resolver
            stateService = resolver.resolve(StateService.self)!
            stateService.statePublisher
                .sink { [weak self] state in
                    self?.appState = state
                }
                .store(in: &subscribers)
//            authService = resolver.resolve(AuthService.self)!
//            authService.statePublisher
//                .assign(to: &$isAuth)
        }
    }
    
}
