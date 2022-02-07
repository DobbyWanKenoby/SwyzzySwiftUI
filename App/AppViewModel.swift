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
        @Published private(set) var isAuth: Bool = false
        
        private var subscriptions: Set<AnyCancellable> = []
        private var resolver: Resolver
        
        // Dependencies
        var authService: AuthService!
        
        init(resolver: Resolver) {
            self.resolver = resolver
            authService = resolver.resolve(AuthService.self)!
            authService.statePublisher
                .assign(to: &$isAuth)
        }
    }
    
}
