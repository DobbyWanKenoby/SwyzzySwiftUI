//
//  UQRootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import Swinject

extension UserQuestionnaireScreenView {

    struct LookFeedView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            VStack {
                VStack(spacing: 20) {
                    Image("lookFeed")
                        .resizable()
                        .scaledToFit()
                    Text("Find out what your friends want")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("View the feed of your friends' wishes and you will always know what they are dreaming of!")
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



struct UQLookFeedView_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.LookFeedView(vm: vm)
    }
}
