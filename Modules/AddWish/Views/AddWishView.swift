//
//  AddWishView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 14.02.2022.
//

import SwiftUI
import Swinject

struct AddWishView: View {
    
    var resolver: Resolver
    
    @StateObject private var vm: ViewModel
    
    @State private var squareSize: CGFloat = 0
    
    init(resolver: Resolver) {
        self.resolver = resolver
        _vm = StateObject(wrappedValue: ViewModel(resolver: resolver))
    }
    
    var body: some View {
        
        Form {
            Section {
                GeometryReader { geometry in
                    ZStack {
                        Button {
                            vm.isShowPickerChanger = true
                        } label: {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.text)
                        }
                        
                        if vm.image != nil {
                            Image(uiImage: vm.image!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                        }
                    }
                    .cornerRadius(10)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .onAppear {
                        squareSize = geometry.size.width
                    }
                    
                }
                .frame(height: squareSize)
                .padding(.vertical)
            } footer: {
                Text("Tap to add image")
            }
            .onTapGesture {
                vm.isShowPickerChanger = true
            }
            Section {
                Button {
                    
                } label: {
                    HStack {
                        Text("Connect to events")
                    }
                    
                }
                
            } footer: {
                Text("You can connect this wish to one or more events")
            }
            Section {
                TextEditor(text: $vm.description)
            } footer: {
                Text("Tell your friends about your wish")
            }
        }
        .confirmationDialog("Choose source of image", isPresented: $vm.isShowPickerChanger, actions: {
            Button("Camera") {
                vm.source = .camera
                vm.isShowPicker = true
            }
            Button("Photo library") {
                vm.source = .photoLibrary
                vm.isShowPicker = true
            }
            Button("Cancel", role: .cancel) {}
        })
        .fullScreenCover(isPresented: $vm.isShowPicker) {
            CameraImagePickerView(image: $vm.image, source: vm.source) {
                vm.isShowPicker = false
            }
            .ignoresSafeArea()
        }
        .alert(vm.alertMessage, isPresented: $vm.isShowAlert) {}
        .toolbar {
            ToolbarItem {
                Button {
                    vm.saveWish()
                } label: {
                    if vm.isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.accent))
                    } else {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}


struct AddWishView_Previews: PreviewProvider {
    static var previews: some View {
        AddWishView(resolver: getPreviewResolver())
    }
}
