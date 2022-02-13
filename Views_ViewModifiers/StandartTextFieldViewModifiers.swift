import SwiftUI

struct StandartTextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
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
}
