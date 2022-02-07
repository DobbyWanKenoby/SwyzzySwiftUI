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
//                Circle()
//                    .trim(from: vm.isAnimate ? 0 : 0.99, to: 1)
//                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                    .fill(RadialGradient(colors: [Color.accent, Color.accent2], center: .top, startRadius: 50, endRadius: 100))
//                    .frame(width: 100, height: 100)
//                    .animation(
//                        Animation
//                            .easeInOut(duration: 2)
//                            .repeatForever(autoreverses: true),
//                        value: vm.isAnimate)
//                    .rotationEffect(.degrees(vm.isAnimate ? 720 : 0))
//                    .animation(
//                        Animation
//                            .linear(duration: 2)
//                            .repeatForever(autoreverses: false),
//                        value: vm.isAnimate)
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
        .fullScreenCover(isPresented: $vm.didEndUpdating) {
            UserQuestionnaireScreenView(resolver: resolver)
        }
    }
}

struct RootView_Previews: PreviewProvider {
      
    static var previews: some View {
        LoadingScreenView(resolver: getPreviewResolver())
    }
}
