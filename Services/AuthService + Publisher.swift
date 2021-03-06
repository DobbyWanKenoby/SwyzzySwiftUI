//
//  AuthService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 06.02.2022.
//

import Foundation

import Combine
import Swinject
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

// MARK: - Protocol

protocol AuthService: AnyObject {
    
    var isAuth: Bool { get }
    
    // get publisher of auth states
    // send event every changing of auth state
    var statePublisher: AnyPublisher<Bool,Never> { get }
    
    init(resolver: Resolver)
    
    // Auth by phone
    func authRequestSMSCode(toPhone: PhoneNumber) -> AnyPublisher<Void,Error>
    func tryAuth(withCode: String) -> AnyPublisher<Void, Error>
}

// MARK: - State Publisher

extension Publishers {
    
    class AuthSubscription<S: Subscriber>: Subscription where S.Input == Bool, S.Failure == Never {
        private var subscriber: S?
        private var handler: AuthStateDidChangeListenerHandle?
        
        init(subscriber: S) {
            self.subscriber = subscriber
            handler = Auth.auth().addStateDidChangeListener { auth, user in
                guard user != nil else {
                    _ = subscriber.receive(false)
                    return
                }
                _ = subscriber.receive(true)
            }
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            handler = nil
        }
        
    }
    
    struct AuthPublisher: Publisher {
        typealias Output = Bool
        typealias Failure = Never
        
        func receive<S: Subscriber>(subscriber: S) where
        AuthPublisher.Failure == S.Failure, AuthPublisher.Output == S.Input {
                let subscription = AuthSubscription(subscriber: subscriber)
                subscriber.receive(subscription: subscription)
        }
    }
        
}

// MARK: - Service Implementation

final class FirebaseAuthService: AuthService {
    
    var isAuth: Bool {
        guard Auth.auth().currentUser != nil else {
            return false
        }
        return true
    }
    
    private var verificationID: String?
    
    lazy var statePublisher: AnyPublisher<Bool,Never> = {
        Publishers.AuthPublisher()
            .eraseToAnyPublisher()
    }()
    
    var resolver: Resolver
    var settingsService: SettingsService
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.settingsService = resolver.resolve(SettingsService.self)!
    }
    
    func authRequestSMSCode(toPhone phone: PhoneNumber) -> AnyPublisher<Void, Error> {
        settingsService.currentUserSettings.phone = phone
        return Future<String, Error> { promise in
            Task {
                do {
                    let id = try await FirebaseAuth.PhoneAuthProvider.provider().verifyPhoneNumber(phone.fullPhone, uiDelegate: nil)
                    promise(.success(id))
                } catch (let error) {
                    promise(.failure(error))
                }
            }
        }
        .map { id in
            self.verificationID = id
            return
        }
        .eraseToAnyPublisher()
    }
    
    func tryAuth(withCode code: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            Task {
                do {
                    guard let verificationID = self.verificationID else {
                        fatalError("You can not use this method before requestSMSCode")
                    }
                    let credentials = FirebaseAuth.PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
                    _ = try await Auth.auth().signIn(with: credentials)
                    promise(.success(Void()))
                } catch (let error) {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
