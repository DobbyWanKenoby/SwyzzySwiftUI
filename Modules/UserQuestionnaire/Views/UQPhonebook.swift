import SwiftUI
import UIKit
import Swinject

extension UserQuestionnaireScreenView {

    struct PhonebookView: View {
        
        @StateObject var vm: ViewModel
        
        var body: some View {
            ZStack {
                VStack {
                    VStack(alignment: .center, spacing: 20) {
                        Image("lookFeed")
                            .resizable()
                            .scaledToFit()
                        Text("Find your friends!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Please, open your phone book to Swizzy so that we can find your friends.")
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    saveButton
                    cancelButton
                    Text("You can give access to the phone book later")
                        .font(.subheadline)
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
        
        private var saveButton: some View {
            Button {
                vm.getPhoneBookAccessAndUploadContacts()
            } label: {
                if !vm.isShowingLoaderOnBirthsdayPage {
                    Text("Give access")
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
            .disabled(vm.isShowingLoaderOnBirthsdayPage)
        }
        
        private var cancelButton: some View {
            Button {
//                vm.saveBirthsdayAndShowNextScreen()
            } label: {
                Text("Skip")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(StandartSecondaryButtonStyle())
            .disabled(vm.isShowingLoaderOnBirthsdayPage)
        }
        
    }
}



struct UQPhonebook_Previews: PreviewProvider {
    
    @StateObject static var vm = UserQuestionnaireScreenView.ViewModel(resolver: getPreviewResolver())
    
    static var previews: some View {
        UserQuestionnaireScreenView.PhonebookView(vm: vm)
    }
}
