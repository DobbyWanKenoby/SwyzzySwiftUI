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
        container.register(PhoneAuthProvider.self) { _ in
            FirebasePhoneAuthProvider()
        }.inObjectScope(.container)
        
        container.register(SMSRequester.self) { r in
            BaseSMSRequester(phoneAuthProvider: r.resolve(PhoneAuthProvider.self)!)
        }.inObjectScope(.container)
    }
}
