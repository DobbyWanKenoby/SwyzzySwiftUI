//
//  UQRootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import Swinject

extension UserQuestionnaireScreenView {

    struct AddGiftView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            VStack {
                VStack(spacing: 20) {
                    Image("addGift")
                        .resizable()
                        .scaledToFit()
                    Text("Add a Gift")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Add the gift you want to receive to your wishlist and share it with your friends.")
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



struct UQAddGiftView_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.AddGiftView(vm: vm)
    }
}
