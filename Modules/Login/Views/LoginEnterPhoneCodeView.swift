//
//  EnterPhoneCodeView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 03.02.2022.
//

import SwiftUI
import Combine

extension LoginScreenView {
    
    struct EnterPhoneCodeView: View {
        
        @ObservedObject var vm: ViewModel
        
        init(viewModel: ViewModel) {
            self.vm = viewModel
        }
        
        var body: some View {
            VStack{
                VStack( alignment: .center, spacing: 10) {
                    Text("Confirmation code")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Enter the code, which sent to \(vm.fullPhoneNumber)")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }
                Spacer()
                VStack(spacing: 10) {
                    TextField("000 000", text: $vm.enteredCode)
                        .keyboardType(.numberPad)
                        .font(.system(size: 50))
                        .multilineTextAlignment(.center)
                        .disabled(vm.showLoadingAlert)
                        .onChange(of: vm.enteredCode) { code in
                            vm.checkEnteredCode()
                        }
                    if vm.showLoadingAlert {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.accent))
                    }
                }
                Spacer()
            }
            .padding(20)
            .alert(vm.codeAlertMessage, isPresented: $vm.showCodeAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
}

struct EnterPhoneCodeView_Previews: PreviewProvider {
    
    @StateObject static var vm = LoginScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        LoginScreenView.EnterPhoneCodeView(viewModel: vm)
    }
}
