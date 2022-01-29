//
//  SMSRequester.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 29.01.2022.
//

import Combine

protocol SMSRequester {
    func requestAuthSMSCode(toPhone phone: String) -> AnyPublisher<String,Error>
}

struct BaseSMSRequester: SMSRequester {
    
    private var phoneAuthProvider: PhoneAuthProvider
    
    init(phoneAuthProvider: PhoneAuthProvider) {
        self.phoneAuthProvider = phoneAuthProvider
    }
    
    func requestAuthSMSCode(toPhone phone: String) -> AnyPublisher<String,Error> {
        return Future<String, Error> { [self] promise in
            Task {
                do {
                    let id = try await phoneAuthProvider.requestSMS(to: phone)
                    promise(.success(id))
                } catch (let error) {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
