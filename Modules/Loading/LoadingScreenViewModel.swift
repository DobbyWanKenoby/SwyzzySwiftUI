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
import FirebaseAuth

extension LoadingScreenView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var isAnimate = false
        
        // Error
        @Published var isShowingAlert = false
        var alertMessage = ""
        
        private var subscribers = Set<AnyCancellable>()
        
        // Dependencies
        private var resolver: Resolver
        private var userService: UserService
        private var phonebookService: PhonebookService
        private var stateService: StateService
        private var authService: AuthService
        private var settingsService: SettingsService
        
        required init(resolver: Resolver) {
            self.resolver = resolver
            userService = resolver.resolve(UserService.self)!
            phonebookService = resolver.resolve(PhonebookService.self)!
            stateService = resolver.resolve(StateService.self)!
            authService = resolver.resolve(AuthService.self)!
            settingsService = resolver.resolve(SettingsService.self)!
        }

        func loadAllNeededData() {
            Task { @MainActor in
                do {
                    
                    guard authService.isAuth else {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        stateService.statePublisher.send(.signOut)
                        return
                    }
                    
                    try await userService.createRemoteUserStructureIfNeeded()
                    let localUser = try await userService.downloadUser()
                    if await phonebookService.isGrantedPhoneBookAccess {
                        let newFriends = try await phonebookService.searchFriendsAmongUsers()
                        // TODO: Add friend download and put it in friends property
//                        localUser.friends = Array(Set(localUser.friends + newFriends))
                    }
                    settingsService.currentUserSettings.lastSearchContacts = Date()
                    await userService.update(user: localUser)
                    try await userService.uploadUser()
                    await showNextScreen()
                } catch FirebaseError.cantGetDocument {
                    // try again
                    // TODO: Rewrite
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    loadAllNeededData()
                } catch (let error) {
                    alertMessage = error.localizedDescription
                    isShowingAlert = true
                }
            }
        }
        
        func showNextScreen() async {
            if await phonebookService.didTryGrantedPhoneBookAccess,
               await userService.user.firstname != "" {
                stateService.statePublisher.send(.needMainFlow)
            } else {
                stateService.statePublisher.send(.needUserQuestionnaire)
            }
        }
    }
    
}
