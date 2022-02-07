//
//  UQRootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import Swinject

extension UserQuestionnaireScreenView {

    struct HelloView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            VStack {
                VStack(spacing: 20) {
                    Image("hello")
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to Swyzzy!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("With Swyzzy, you always know what your friend dreams about, and you yourself can post the gifts you want to receive. It's that simple!")
                        .multilineTextAlignment(.center)
                }
                Spacer()
                Button {
                    vm.showNextScreen()
                } label: {
                    Text("Next")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(StandartButtonStyle())

            }
            .padding()
        }
    }
}



struct UQHelloView_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.HelloView(vm: vm)
    }
}
