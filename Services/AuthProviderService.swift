//
//  AuthProviderService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 27.01.2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine

class AuthProviderFactory {}

// MARK: Phone authorization

protocol PhoneAuthProvider {
    func requestSMS(to: String) async throws -> String
}

class FirebasePhoneAuthProvider: PhoneAuthProvider {
    
    func requestSMS(to phoneNumber: String) async throws -> String  {
         return try await FirebaseAuth.PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
    }
    
    func auth(withCode code: String, andVerificationID verificationID: String) async throws {
        let credential = FirebaseAuth.PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        let _ = try await Auth.auth().signIn(with: credential)
        
        guard Auth.auth().currentUser != nil else {
            throw AuthError.missingCredentials
        }
    }
}
