//
//  Loader.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 07.02.2022.
//

import SwiftUI

struct LoaderView: View {
    
    @State private var isAnimate = false
    
    var body: some View {
        animatedCircle
            .onAppear {
                isAnimate = true
            }
    }
    
    var animatedCircle: some View {
        Circle()
            .trim(from: isAnimate ? 0 : 0.99, to: 1)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .fill(RadialGradient(colors: [Color.accent, Color.accent2], center: .top, startRadius: 50, endRadius: 100))
            .animation(
                Animation
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                value: isAnimate)
            .rotationEffect(.degrees(isAnimate ? 720 : 0))
            .animation(
                Animation
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false),
                value: isAnimate)
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            LoaderView()
        }
        
            
    }
}
