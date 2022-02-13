import SwiftUI

struct BlurViewModifier: ViewModifier {
    
    @Binding var isBlur: Bool
    
    func body(content: Content) -> some View {
        if isBlur {
            content
                .blur(radius: 5)
        } else {
            content
        }
    }
}
