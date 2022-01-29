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

extension LoginScreen {
    
    class ViewModel: ObservableObject {
        
        @Published var countries: [Country] = []
        @Published var currentCountry: Country!
        @Published var isShowingSetCountryScreen = false
        @Published var phoneNumber: String = ""
        
        // error alert
        @Published var errorMessage: String = "Sample error"
        @Published var showErrorMessage = false
        
        var subscriptions: Set<AnyCancellable> = []
        
        // Dependencies
        private var resolver: Resolver
        private var phoneAuthProvider: PhoneAuthProvider
        private var smsRequester: SMSRequester
        private var countryDataService: CountryDataService
        
        init(resolver: Resolver) {
            self.resolver = resolver
            
            // Inject dependecies
            phoneAuthProvider = resolver.resolve(PhoneAuthProvider.self)!
            smsRequester = resolver.resolve(SMSRequester.self)!
            countryDataService = resolver.resolve(CountryDataService.self)!

            countries = countryDataService.countries
            currentCountry = countryDataService.countries.last!
        }
        
        private var verificationID: String?
        
        func requestSMS(
            before: (() -> Void)? = nil,
            after: (() -> Void)? = nil) {
            before?()
            smsRequester
                .requestAuthSMSCode(toPhone: currentCountry.phoneCode + phoneNumber)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [self] completion in
                    switch completion {
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        showErrorMessage = true
                        after?()
                    case .finished:
                        return
                    }
                }, receiveValue: { value in
                    after?()
                })
                .store(in: &subscriptions)
        }
    }
    
}
