//
//  UQRootView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 05.02.2022.
//

import SwiftUI
import UIKit
import Swinject

extension UserQuestionnaireScreenView {

    struct EnterNameView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            ZStack {
                VStack {
                    VStack(spacing: 20) {
                        Image("lookFeed")
                            .resizable()
                            .scaledToFit()
                        Text("Let's get acquainted!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Enter your first and last name")
                            .multilineTextAlignment(.center)
                        VStack(spacing: 20) {
                            TextField("Luke", text: $vm.firstName)
                                .textContentType(UIKit.UITextContentType.name)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .modifier(StandartTextFieldViewModifier())
                            TextField("Skywalker", text: $vm.lastName)
                                .textContentType(UIKit.UITextContentType.familyName)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .modifier(StandartTextFieldViewModifier())
                        }
                        .padding(20)
                        
                    }
                    Spacer()
                    sendButton

                }
                .padding()
            }
            
        }
        
        @ViewBuilder
        private var loaderView: some View {
            Color.gray
                .opacity(0.5)
                .ignoresSafeArea()
            LoaderView()
                .frame(width: 50, height: 50)
        }
        
        private var sendButton: some View {
            Button {
                vm.saveUserNameAndShowNextScreen()
            } label: {
                if !vm.isShowingLoaderOnEnterNamePage {
                    Text("Save")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.accentButtonText))
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(StandartButtonStyle())
            .disabled(vm.isShowingLoaderOnEnterNamePage)
        }
    }
}



struct UQEnterNameView_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.EnterNameView(vm: vm)
    }
}
