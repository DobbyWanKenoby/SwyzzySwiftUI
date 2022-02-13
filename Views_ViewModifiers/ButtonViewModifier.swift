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
                .foregroundColor(isEnabled ? Color.accentButtonText : Color(UIColor.systemGray2))
                .background(isEnabled ? Color.accent : Color.accent.opacity(0.3))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
    }
}

// MARK: - Style of standart secondary Swyzzy's button

struct StandartSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StandartSecondaryButtonView(configuration: configuration)
    }
}

private extension StandartSecondaryButtonStyle {
    struct StandartSecondaryButtonView: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: StandartSecondaryButtonStyle.Configuration
        
        var body: some View {
            return configuration.label
                .foregroundColor(isEnabled ? Color.secondaryButtonText : Color(UIColor.systemGray2))
                .background(isEnabled ? Color.secondaryButton : Color.secondaryButton.opacity(0.3))
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
            
            Button {} label: {
                Text("My Button")
                    .frame(width: 200, height: 55)
            }
            .buttonStyle(StandartButtonStyle())
            
            Button {} label: {
                Text("My Button")
                    .frame(width: 200, height: 55)
            }
            .buttonStyle(StandartSecondaryButtonStyle())

        }

    }
}
