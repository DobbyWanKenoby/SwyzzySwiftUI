//
//  CameraImagePickerView.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 15.02.2022.
//

import SwiftUI


struct CameraImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var source: UIImagePickerController.SourceType
    var didEnd: (() -> Void)?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIImagePickerController {
        let picker = getPickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    private func getPickerController() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = ["public.image"]
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, didEnd: didEnd)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<Self>) {}
    
}

extension CameraImagePickerView {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private var didEnd: (() -> Void)?
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>, didEnd: (()->Void)?) {
            _image = image
            self.didEnd = didEnd
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            image = unwrapImage
            didEnd?()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            didEnd?()
        }
    }
    
}





