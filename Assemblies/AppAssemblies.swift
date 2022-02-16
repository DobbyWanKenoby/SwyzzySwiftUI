//
//  DataServices.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import Swinject

class BaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CountryDataService.self) { _ in
            PlistCountryDataService()
        }.inObjectScope(.container)
        
        container.register(SettingsService.self) { _ in
            BaseSettingsService()
        }.inObjectScope(.container)
        
        container.register(StateService.self) { _ in
            BaseStateService()
        }.inObjectScope(.container)
        
        container.register(AuthService.self) { r in
            FirebaseAuthService(resolver: r)
        }.inObjectScope(.container)
        
        container.register(UserService.self) { r in
            FirebaseUserService(resolver: r)
        }.inObjectScope(.container)
        
        container.register(WishService.self) { _ in
            FirebaseWishService()
        }.inObjectScope(.container)
        
        container.register(EventService.self) { r in
            FirebaseEventService()
        }.inObjectScope(.container)
        
        container.register(PhonebookService.self) { r in
            FirebasePhonebookService(resolver: r)
        }.inObjectScope(.container)
        
        
    }
}
