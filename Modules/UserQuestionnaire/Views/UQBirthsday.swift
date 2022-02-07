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

    struct BirthsdayView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            ZStack {
                VStack {
                    VStack(alignment: .center, spacing: 20) {
                        Image("lookFeed")
                            .resizable()
                            .scaledToFit()
                        Text("When is your birthday?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Please include your date of birth so that we can create the first event on your calendar.")
                            .multilineTextAlignment(.center)
                        DatePicker("", selection: $vm.birthsday, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .padding()
                            .fixedSize()
                            .frame(maxWidth: .infinity)
                    }
                    Spacer()
                    Button {
                        vm.saveBirthsdayAndShowNextScreen()
                    } label: {
                        Text("Save")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(StandartButtonStyle())

                }
                .padding()
                .modifier(BlurViewModifier(isBlur: $vm.isShowingLoaderOnBirthsdayPage))
                if vm.isShowingLoaderOnBirthsdayPage {
                    loaderView
                        .animation(.easeInOut(duration: 0.3), value: vm.isShowingLoaderOnBirthsdayPage)
                }
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
        
    }
}



struct UQBirthsdayViewView_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.BirthsdayView(vm: vm)
    }
}
