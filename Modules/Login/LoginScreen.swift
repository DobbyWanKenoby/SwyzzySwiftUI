//
//  LoginScreen.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 28.01.2022.
//

import Foundation
import Swinject
import SwiftUI

struct LoginScreen: Screen {
    // Shared protperties for views and models
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var rootView: some View {
        let viewModel = ViewModel(resolver: resolver)
        return RootView(vm: viewModel)
    }

}
