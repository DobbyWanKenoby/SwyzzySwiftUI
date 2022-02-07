//
//  LoadingScreenViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import Foundation
import Combine
import SwiftUI
import Swinject

extension UserQuestionnaireScreenView {
    
    @MainActor
    final class ViewModel: BaseModel {
        
        @Published var didEndUpdating = false
        @Published var isAnimate = false
        @Published var currentScreen: SubScreen = .enterName
        
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        @Published var birthsday: Date = Date()
        
        // Error
        @Published var isShowingAlert = false
        var alertMessage = ""
        
        // Loader
        @Published var isShowingLoaderOnEnterNamePage: Bool = false
        @Published var isShowingLoaderOnBirthsdayPage: Bool = false
        
        private var subscriptions = Set<AnyCancellable>()
        
        // Dependencies
        private var resolver: Resolver
        private var userService: UserService
        
        required init(resolver: Resolver) {
            self.resolver = resolver
            userService = resolver.resolve(UserService.self)!
        }
        
        func showNextScreen() {
            withAnimation {
                switch currentScreen {
                case .hello:
                    currentScreen = .addGift
                case .addGift:
                    currentScreen = .lookFeed
                case .lookFeed:
                    currentScreen = .enterName
                case .enterName:
                    currentScreen = .birthsday
                default:
                    return
                }
            }
        }
        
        func saveUserNameAndShowNextScreen() {
            let _firstname = firstName.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            let _lastname = lastName.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            guard _firstname != "", _lastname != "" else {
                      alertMessage = "You have to enter first and last name to continue"
                      isShowingAlert = true
                      return
                  }
            withAnimation {
                isShowingLoaderOnEnterNamePage = true
            }
            
            Task {
                guard var localUser = await userService.user else { return }
                localUser.firstname = _firstname
                localUser.lastname = _lastname
                await userService.update(user: localUser)
                do {
                    try await userService.uploadUser()
                } catch {
                    isShowingLoaderOnEnterNamePage = false
                    alertMessage = "Can not save data. Please try again"
                    isShowingAlert = true
                }
                isShowingLoaderOnEnterNamePage = false
                showNextScreen()
            }
        }
        
        func saveBirthsdayAndShowNextScreen() {

            withAnimation {
                isShowingLoaderOnBirthsdayPage = true
            }
            
            Task {
                guard var localUser = await userService.user else { return }
                localUser.birthsday = birthsday

                await userService.update(user: localUser)
                do {
                    try await userService.uploadUser()
                } catch {
                    isShowingLoaderOnBirthsdayPage = false
                    alertMessage = "Can not save data. Please try again"
                    isShowingAlert = true
                }
                isShowingLoaderOnBirthsdayPage = false
                showNextScreen()
            }
        }

    }
    
    enum SubScreen {
        case hello
        case addGift
        case lookFeed
        case enterName
        case birthsday
    }
    
    
}

