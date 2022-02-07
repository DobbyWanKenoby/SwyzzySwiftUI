//
//  UQRootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import Swinject

struct UserQuestionnaireScreenView: BaseView {
    
    @StateObject
    var vm: ViewModel
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _vm = StateObject(wrappedValue: ViewModel(resolver: resolver))
    }
    
    var body: some View {
        ZStack {
            currentPage
                .modifier(SubScreenTransitionModifier())
        }
        .alert(vm.alertMessage, isPresented: $vm.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    var currentPage: some View {
        switch vm.currentScreen {
        case .hello:
            HelloView(vm: vm)
        case .addGift:
            AddGiftView(vm: vm)
        case .lookFeed:
            LookFeedView(vm: vm)
        case .enterName:
            EnterNameView(vm: vm)
        case .birthsday:
            BirthsdayView(vm: vm)
        }
    }
}

extension UserQuestionnaireScreenView {
    struct SubScreenTransitionModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        }
    }
}

struct UQRootView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserQuestionnaireScreenView(resolver: getPreviewResolver())
    }
}
