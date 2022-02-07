//
//  LoginScreenView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import SwiftUI
import Swinject

struct LoginScreenView: BaseView {
    @StateObject var vm: ViewModel
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _vm = StateObject(wrappedValue: ViewModel(resolver: resolver))
    }
    
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
                        .disabled(!vm.isEnableSendButton)
                    sendCodeText
                }
                Spacer()
            }
        }
        .alert(vm.rootAlertMessage, isPresented: $vm.showRootAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(item: $vm.sheet, content: { item in
            switch item {
            case .country:
                SelectCountryView(countries: vm.countries, current: $vm.currentCountry)
            case .phoneCode:
                EnterPhoneCodeView(viewModel: vm)
            }
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
            vm.sheet = .country
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
            .font(.title3)
            .frame(height: 55)
        }
        .buttonStyle(StandartButtonStyle())
    }
    
    private var phoneNumberTextField: some View {
        TextField("Phone Number", text: $vm.phoneNumber)
            .keyboardType(.phonePad)
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
            vm.requestSMS()
        } label: {
            if vm.isEnableSendButton {
                Text("Send Code")
                    .font(.title3)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.accentButton))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(StandartButtonStyle())
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

extension LoginScreenView {
    
    enum ActiveSheet: Identifiable {
        case country
        case phoneCode
        
        var id: Int {
            hashValue
        }
    }
    
}

struct LoginScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginScreenView(resolver: getPreviewResolver())
    }
}
