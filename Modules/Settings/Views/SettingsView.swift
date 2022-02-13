//
//  SettingsView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 10.02.2022.
//

import SwiftUI
import Swinject

struct SettingsView: View {
    
    @StateObject var vm: ViewModel
    private var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _vm = StateObject(wrappedValue: ViewModel(resolver: resolver))
    }
    
    var body: some View {
        Form {
            Section {
                signOutButton
            }
        }
        .navigationBarTitle("Settings")
        .alert(vm.alertMessage, isPresented: $vm.isShowingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    private var signOutButton: some View {
        Button {
            vm.signOut()
        } label: {
            Text("Sign out")
                .fontWeight(.medium)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(resolver: getPreviewResolver())
    }
}
