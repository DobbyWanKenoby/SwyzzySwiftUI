//
//  RootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import Swinject

struct LoadingScreenView: BaseView {
    
    @StateObject var vm: ViewModel
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _vm = StateObject(wrappedValue: ViewModel(resolver: resolver))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                LoaderView()
                    .frame(width: 100, height: 100)
                Text("Updating data")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .onAppear {
            vm.isAnimate = true
            vm.loadAllNeededData()
        }
        .alert(vm.alertMessage, isPresented: $vm.isShowingAlert) {
            Button("OK", role: .cancel) {}
        }
//        .fullScreenCover(isPresented: $vm.didEndUpdating) {
//            UserQuestionnaireScreenView(resolver: resolver)
//        }
    }
}

struct RootView_Previews: PreviewProvider {
      
    static var previews: some View {
        LoadingScreenView(resolver: getPreviewResolver())
    }
}
