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
        @Published var currentScreen: SubScreen = .hello
        
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        @Published var birthday: Date = Date()
        
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
        private var eventService: EventService
        private var phonebookService: PhonebookService
        private var stateService: StateService
        
        required init(resolver: Resolver) {
            self.resolver = resolver
            userService = resolver.resolve(UserService.self)!
            eventService = resolver.resolve(EventService.self)!
            phonebookService = resolver.resolve(PhonebookService.self)!
            stateService = resolver.resolve(StateService.self)!
        }
        
        func showNextScreen() {
            switch currentScreen {
            case .hello:
                currentScreen = .addGift
            case .addGift:
                currentScreen = .lookFeed
            case .lookFeed:
                currentScreen = .enterName
            case .enterName:
                currentScreen = .birthday
            case .birthday:
                currentScreen = .phonebook
            case .phonebook:
                stateService.statePublisher.send(.needMainFlow)
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
                guard let localUser = await userService.user else { return }
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
                guard let localUser = await userService.user else { return }
                localUser.birthday = birthday

                await userService.update(user: localUser)
                do {
                    async let _ = try await userService.uploadUser()
                    async let _ = try await eventService.create(event: Event(
                        title: NSLocalizedString("My Birthday", comment: ""),
                        date: getNextBirthdayDate(birthday)))
                } catch {
                    isShowingLoaderOnBirthsdayPage = false
                    alertMessage = NSLocalizedString("Can not save data. Please try again", comment: "Error if saving data about birthday has finished with error")
                    isShowingAlert = true
                }
                isShowingLoaderOnBirthsdayPage = false
                showNextScreen()
            }
        }
        
        private func getNextBirthdayDate(_ birthday: Date) -> Date {
            var mutableDate = birthday
            let currentDate = Date()
            while(mutableDate < currentDate) {
                mutableDate = Calendar.current.date(byAdding: .year, value: 1, to: mutableDate)!
            }
            return mutableDate
        }
        
        func getPhoneBookAccessAndUploadContacts() {
            Task {
                do {
                    _ = try await phonebookService.getPhoneBookAccess()
                    showNextScreen()
                } catch( let error ) {
                    isShowingAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }

    }
    
    enum SubScreen {
        case hello
        case addGift
        case lookFeed
        case enterName
        case birthday
        case phonebook
    }
    
    
}

