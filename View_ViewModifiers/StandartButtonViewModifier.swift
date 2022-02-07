import SwiftUI

struct StandartButtonHeightViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
    }
}

// MARK: - Style of standart Swyzzy's button

struct StandartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StandartButtonView(configuration: configuration)
    }
}

private extension StandartButtonStyle {
    struct StandartButtonView: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: StandartButtonStyle.Configuration
        
        var body: some View {
            return configuration.label
                .foregroundColor(isEnabled ? Color.accentButton : Color(UIColor.systemGray2))
                .background(isEnabled ? Color.accent : Color.accent.opacity(0.3))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    
    @State var dis: Bool = false
    
    static var previews: some View {
        
        VStack {
            Button {
//                dis.toggle()
            } label: {
                Text("HelloMyName")
                    .modifier(StandartButtonHeightViewModifier())
                    .padding()
//                    .frame(minWidth: .infinity)
                    
            }
            .frame(minWidth: 200)
            .buttonStyle(StandartButtonStyle())
            
        }

    }
}
