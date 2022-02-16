//
//  AddWishViewModel.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 15.02.2022.
//

import UIKit
import Swinject
import SwiftUI

extension AddWishView {
    
    @MainActor
    class ViewModel: BaseModel {
        
        @Published var image: UIImage?
        @Published var isShowPickerChanger = false
        @Published var isShowPicker = false
        @Published var isSaving = false
        var description = ""
        var source: UIImagePickerController.SourceType = .camera
        
        // Alert
        @Published var alertMessage = ""
        @Published var isShowAlert = false
        
        // Dependecies
        private var resolver: Resolver
        lazy private var wishService: WishService = {
            resolver.resolve(WishService.self)!
        }()
        lazy private var userService: UserService = {
            resolver.resolve(UserService.self)!
        }()
        
        init(resolver: Resolver) {
            self.resolver = resolver
        }
        
        func saveWish() {
            guard !isSaving else { return }
            guard let image = image else {
                alertMessage = "You have to add image before save"
                isShowAlert = true
                return
            }

            Task {
                do {
                    isSaving = true
                    let wish = Wish(resolver: resolver,
                                    description: description,
                                    createDate: Date(),
                                    user: await userService.user)
                    try await wishService.create(wish: wish, image: image)
                    alertMessage = "Wish did save"
                    isShowAlert = true
                    resetWish()
                } catch (let error) {
                    alertMessage = error.localizedDescription
                    isShowAlert = true
                    isSaving = false
                }
            }
        }
        
        func resetWish() {
            isSaving = false
            withAnimation {
                description = ""
                image = nil
            }
        }
        
    }
}
