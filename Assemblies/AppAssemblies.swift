//
//  DataServices.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import Swinject

class DataServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CountryDataService.self) { _ in
            PlistCountryDataService()
        }.inObjectScope(.container)
    }
}

class FirebaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserService.self) { r in
            FirebaseUserService()
        }.inObjectScope(.container)
        
        container.register(AuthService.self) { _ in
            FirebaseAuthService()
        }.inObjectScope(.container)
    }
}
