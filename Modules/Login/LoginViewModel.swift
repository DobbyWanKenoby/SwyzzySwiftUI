//
//  LoginScreenViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import Foundation
import Swinject
import Combine
import FirebaseAuth

extension LoginScreenView {
    
    @MainActor
    final class ViewModel: BaseModel {
        
        // Root View
        // - alert
        @Published var showRootAlert = false
        var rootAlertMessage = ""
        
        var countries: [Country] {
            return countryDataService.countries
        }
        @Published var currentCountry: Country!
        @Published var sheet: ActiveSheet?
        @Published var isEnableSendButton = true
        @Published var phoneNumber = ""
        var fullPhoneNumber: String {
            currentCountry.phoneCode + phoneNumber
        }
        
        // EnterPhoneCode View
        @Published var enteredCode = ""
        // - count of chars at code
        private var codeCharsCount = 6
        // - alert
        @Published var showLoadingAlert = false
        @Published var showCodeAlert = false
        var codeAlertMessage = ""
        
        var subscriptions: Set<AnyCancellable> = []
        
        // Dependencies
        private var resolver: Resolver
        private var authService: AuthService
        private var stateService: StateService
        private var countryDataService: CountryDataService
        
        init(resolver: Resolver) {
            self.resolver = resolver
            
            // Inject dependecies
            stateService = resolver.resolve(StateService.self)!
            authService = resolver.resolve(AuthService.self)!
            countryDataService = resolver.resolve(CountryDataService.self)!
            
            currentCountry = countries.first!
        }
        
        private var verificationID: String?
        
        func requestSMS() {
            isEnableSendButton = false
            let phone = PhoneNumber(countryCode: currentCountry.phoneCode, phone: phoneNumber)
            
            authService
                .authRequestSMSCode(toPhone: phone)
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] completion in
                    switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        self.rootAlertMessage = error.localizedDescription
                        self.showRootAlert = true
                        self.isEnableSendButton = true
                    }
                } receiveValue: { [unowned self] _ in
                    self.isEnableSendButton = true
                    sheet = .phoneCode
                }
                .store(in: &subscriptions)
        }
        
        func checkEnteredCode() {
            guard enteredCode.count <= codeCharsCount else {
                enteredCode = enteredCode.substring(toIndex: codeCharsCount)
                return
            }
            guard enteredCode.count == codeCharsCount else {
                return
            }
            
            self.showLoadingAlert = true
            authService
                .tryAuth(withCode: enteredCode)
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] completion in
                    switch completion {
                    case .failure(let error):
                        codeAlertMessage = error.localizedDescription
                        showCodeAlert = true
                        showLoadingAlert = false
                    case .finished:
                        return
                    }
                } receiveValue: { [unowned self] _ in
                    stateService.statePublisher.send(.signIn)
                    sheet = .none
                }
                .store(in: &subscriptions)

        
        }
    }
}
