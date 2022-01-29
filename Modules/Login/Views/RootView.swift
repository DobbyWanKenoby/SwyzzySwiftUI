//
//  LoginScreenView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import SwiftUI
import Swinject

extension LoginScreen {
    
    struct RootView: View {
        
        @StateObject var vm: ViewModel
        
        @State var isEnableSendButton = true
        
        var body: some View {
            ZStack {
                VStack {
                    logoImage
                    Spacer()
                    termsText
                }
                VStack {
                    Spacer()
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            phoneCodeButton
                            phoneNumberTextField
                        }
                        sendCodeButton
                            .disabled(!isEnableSendButton)
                        sendCodeText
                    }
                    Spacer()
                }
            }
            .alert(vm.errorMessage, isPresented: $vm.showErrorMessage) {
                Button("OK", role: .cancel) {}
            }
            .sheet(isPresented: $vm.isShowingSetCountryScreen, content: {
                SelectCountryView(countries: vm.countries, current: $vm.currentCountry)
            })
            .padding(20)
            .ignoresSafeArea()
        }
        
        private var logoImage: some View {
            Image("Title")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 60)
                .padding(.top, 80)
        }
        
        private var phoneCodeButton: some View {
            Button {
                vm.isShowingSetCountryScreen = true
            } label: {
                HStack {
                    Image(vm.currentCountry.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                    Text(vm.currentCountry.phoneCode)
                }
                .padding(.horizontal, 10)
                .foregroundColor(Color.accentButton)
                .font(.title3)
                .frame(height: 55)
                .background(Color.accent)
                .cornerRadius(10)
                .shadow(color: Color.accent.opacity(0.8), radius: 5, x: 0, y: 0)
            }
        }
        
        private var phoneNumberTextField: some View {
            TextField("Phone Number", text: $vm.phoneNumber)
                .font(.title3)
                .foregroundColor(Color.text)
                .padding()
                .frame(height: 55)
                .background(Color.textFieldBackground)
                .cornerRadius(10)
                .padding(1)
                .background(
                    Color.textFieldBorder
                        .cornerRadius(10)
                )
        }
        
        private var sendCodeButton: some View {
            Button {
                vm.requestSMS {
                    isEnableSendButton = false
                } after: {
                    isEnableSendButton = true
                }

            } label: {
                if isEnableSendButton {
                    Text("Send Code")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.accentButton))
                }
            }
            .foregroundColor(Color.accentButton)
            .font(.title3)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                isEnableSendButton ? Color.accent : Color.gray
            )
            .cornerRadius(10)
            .shadow(color: isEnableSendButton ? Color.accent.opacity(0.8) : Color.gray.opacity(0.8), radius: 5, x: 0, y: 0)
            .animation(.easeInOut, value: isEnableSendButton)
        }
        
        private var sendCodeText: some View {
            Text("Incoming SMS may be charged in accordance with the tariffs of your operator")
                .font(.footnote)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
        }
        
        private var termsText: some View {
            Text("By creating an account, you agree to our Terms of Service. More about how we use your data - in the Privacy Policy")
                .font(.footnote)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct LoginScreenView_Previews: PreviewProvider {
    
    @StateObject static var vm = LoginScreen.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        LoginScreen.RootView(vm: vm)
    }
}
